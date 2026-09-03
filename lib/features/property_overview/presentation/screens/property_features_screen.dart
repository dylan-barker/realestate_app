import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/feature_list_widget.dart';
import '../../../../core/widgets/real_estate_dialog.dart';
import '../../../../core/widgets/wizard_app_bar.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../providers/property_provider.dart';
import '../widgets/add_room_sheet.dart';

const _parkingTypes = {
  1: 'Single Garage',
  2: 'Double Garage',
  3: 'Triple Garage',
  4: 'Carport',
  5: 'Off-Street Parking',
  6: 'Undercover Parking',
};

class PropertyFeaturesScreen extends ConsumerWidget {
  const PropertyFeaturesScreen({super.key});

  void _showAddOutdoorFeatureDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String feature = '';

    showRealEstateDialog(
      context: context,
      title: 'Add Outdoor Feature',
      theme: theme,
      content: CustomTextInput(
        theme: theme,
        label: 'Feature Name',
        placeholder: 'e.g. Trampoline, Outdoor Kitchen',
        onChanged: (val) => feature = val,
      ),
      actions: [
        dialogCancelButton(context: context, theme: theme),
        dialogActionButton(
          theme: theme,
          text: 'Add',
          onPressed: () {
            if (feature.trim().isNotEmpty) {
              viewModel.addOutdoorFeature(feature.trim());
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Future<void> _saveAndPop(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    await viewModel.savePropertyFeatures();
    if (!context.mounted) return;
    Navigator.pop(context);
    final error = ref.read(propertyViewModelProvider).errorMessage;
    if (error != null && context.mounted) {
      final theme = ref.read(themeConfigProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlySaveMessage(error, 'property features')),
          backgroundColor: theme.error,
        ),
      );
    }
    if (context.mounted) context.pop();
  }

  void _confirmDeleteRoom(
    BuildContext context,
    PropertyViewModel viewModel,
    String roomId,
    String roomName,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    showRealEstateDialog(
      context: context,
      title: 'Remove Room',
      theme: theme,
      content: Text(
        'Are you sure you want to remove "$roomName"?',
        style: textTheme.bodyLarge,
      ),
      actions: [
        dialogCancelButton(context: context, theme: theme),
        dialogActionButton(
          theme: theme,
          text: 'Remove',
          onPressed: () {
            viewModel.removeRoom(roomId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeConfigProvider);
    final textTheme = theme.toThemeData().textTheme;

    final listingId = state.listingId;
    final rooms = state.rooms;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _saveAndPop(context, ref);
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: WizardAppBar(
          title: 'Property Features',
          onBack: () => Navigator.maybePop(context),
          theme: theme,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Features',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detail and configure every room in the residence.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'ROOMS',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textLabel,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${rooms.length}',
                        style: textTheme.labelLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.borderLight),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rooms.isEmpty) ...[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'No rooms added yet.',
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => AddRoomSheet.show(
                              context,
                              viewModel,
                              theme,
                              textTheme,
                            ),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Room'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.onPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rooms.length,
                          itemBuilder: (context, idx) {
                            final room = rooms[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  viewModel.selectRoomForEditing(room.id);
                                  context.push(
                                    AppRoutes.roomDetails(listingId!, room.id),
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.backgroundColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.borderLight.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              room.name,
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.textPrimary,
                                                  ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              room.conditionRating != null
                                                  ? 'Condition: Level ${room.conditionRating}'
                                                  : 'Condition: Not rated',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        room.conditionRating !=
                                                            null
                                                        ? theme.completeColor
                                                        : theme.pendingColor,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _confirmDeleteRoom(
                                          context,
                                          viewModel,
                                          room.id,
                                          room.name,
                                          theme,
                                          textTheme,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: theme.borderLight.withValues(
                                              alpha: 0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.delete_outline,
                                            size: 16,
                                            color: theme.textSecondary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: theme.textSecondary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => AddRoomSheet.show(
                              context,
                              viewModel,
                              theme,
                              textTheme,
                            ),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Room'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.onPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(height: 1, color: theme.borderLight),
                const SizedBox(height: 20),
                Text(
                  'PARKING',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textLabel,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                ..._parkingTypes.entries.map((e) {
                  final label = e.value;
                  final pid = e.key;
                  final parkingItem = state.parking
                      .where((p) => p.parkingTypeId == pid)
                      .firstOrNull;
                  final qty = parkingItem?.quantity ?? 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: qty > 0 ? theme.primaryColor : theme.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: qty > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: theme.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, size: 20),
                          color: qty > 0
                              ? theme.primaryColor
                              : theme.borderLight,
                          onPressed: qty > 0
                              ? () => viewModel.decrementParking(pid)
                              : null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                        Text(
                          '$qty',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, size: 20),
                          color: theme.primaryColor,
                          onPressed: () => viewModel.addParking(e.key),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 32),
                Container(height: 1, color: theme.borderLight),
                const SizedBox(height: 20),
                Text(
                  'OUTDOOR FEATURES',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textLabel,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                () {
                  final allOutdoorExtras = OutdoorExtra.values
                      .map((e) => e.displayString)
                      .toSet();
                  return Column(
                    children: [
                      ...OutdoorExtraCategory.values.map((category) {
                        final extras = OutdoorExtra.values
                            .where((e) => e.category == category)
                            .map((e) => e.displayString)
                            .toList();
                        final selectedForCategory = state.outdoorFeatures
                            .where((f) => extras.contains(f))
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.displayString,
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FeatureListWidget(
                                selectedFeatures: selectedForCategory,
                                availableDefaults: extras,
                                onAdd: (f) => viewModel.addOutdoorFeature(f),
                                onRemove: (f) =>
                                    viewModel.removeOutdoorFeature(f),
                                categoryLabel: category.displayString,
                                theme: theme,
                                textTheme: textTheme,
                              ),
                            ],
                          ),
                        );
                      }),
                      () {
                        final customFeatures = state.outdoorFeatures
                            .where((f) => !allOutdoorExtras.contains(f))
                            .toList();
                        if (customFeatures.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Custom',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...customFeatures.map(
                                (f) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.cardBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.borderLight,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.build_outlined,
                                        size: 18,
                                        color: theme.textSecondary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: theme.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: theme.textSecondary,
                                        ),
                                        onPressed: () =>
                                            viewModel.removeOutdoorFeature(f),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }(),
                    ],
                  );
                }(),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddOutdoorFeatureDialog(
                      context,
                      viewModel,
                      theme,
                      textTheme,
                    ),
                    icon: const Icon(Icons.add, size: 22),
                    label: const Text('ADD CUSTOM OUTDOOR FEATURE'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.cardBackgroundColor,
                      foregroundColor: theme.primaryColor,
                      side: BorderSide(
                        color: theme.primaryColor.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
