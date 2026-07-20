import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/real_estate_dialog.dart';
import '../../../../core/widgets/wizard_app_bar.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../data/models/enums/room_category.dart';
import '../../data/models/room.dart';
import '../../providers/property_provider.dart';
import '../widgets/room_section.dart';

class PropertyFeaturesStep extends ConsumerWidget {
  const PropertyFeaturesStep({super.key});

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
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    await viewModel.savePropertyFeatures();
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeConfigProvider);
    final textTheme = theme.toThemeData().textTheme;

    final listingId = state.listingId;
    final categories = RoomCategory.values;

    Map<RoomCategory, List<Room>> groupedRooms = {
      for (var cat in categories) cat: [],
    };
    for (var room in state.rooms) {
      final cat = RoomCategory.values.firstWhere(
        (c) => c.index + 1 == room.roomTypeId,
        orElse: () => RoomCategory.additional,
      );
      if (groupedRooms.containsKey(cat)) {
        groupedRooms[cat]!.add(room);
      }
    }

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: WizardAppBar(
        title: 'Property Features',
        onBack: () => _saveAndPop(context, ref),
        theme: theme,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
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
              Text(
                'ROOMS',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textLabel,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              for (var category in categories) ...[
                RoomSection(
                  theme: theme,
                  textTheme: textTheme,
                  category: category,
                  rooms: groupedRooms[category]!,
                  viewModel: viewModel,
                  onRoomTap: (roomId) =>
                      context.push('/property/$listingId/room-details/$roomId'),
                ),
                const SizedBox(height: 12),
              ],
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
              Wrap(
                spacing: 8.0,
                runSpacing: 10.0,
                children:
                    [
                      {'id': 1, 'label': 'Single Garage'},
                      {'id': 2, 'label': 'Double Garage'},
                      {'id': 3, 'label': 'Triple Garage'},
                      {'id': 4, 'label': 'Carport'},
                      {'id': 5, 'label': 'Off-Street Parking'},
                      {'id': 6, 'label': 'Undercover Parking'},
                    ].map((p) {
                      final pid = p['id'] as int;
                      final label = p['label'] as String;
                      final parkingItem = state.parking
                          .where((p) => p.parkingTypeId == pid)
                          .firstOrNull;
                      final isSelected = parkingItem != null;
                      return CustomChip(
                        theme: theme,
                        label: isSelected
                            ? '$label x${parkingItem.quantity}'
                            : label,
                        isSelected: isSelected,
                        onTap: () {
                          if (isSelected) {
                            viewModel.removeParking(pid);
                          } else {
                            viewModel.addParking(pid);
                          }
                        },
                      );
                    }).toList(),
              ),
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
              ...OutdoorExtraCategory.values.map((category) {
                final extras = OutdoorExtra.values
                    .where((e) => e.category == category)
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
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: extras.map((extra) {
                          final isSelected = state.outdoorFeatures.contains(
                            extra.displayString,
                          );
                          return CustomChip(
                            theme: theme,
                            label: extra.displayString,
                            isSelected: isSelected,
                            onTap: () {
                              if (isSelected) {
                                viewModel.removeOutdoorFeature(
                                  extra.displayString,
                                );
                              } else {
                                viewModel.addOutdoorFeature(
                                  extra.displayString,
                                );
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              if (state.outdoorFeatures
                  .where((f) => OutdoorExtra.fromString(f) == null)
                  .isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
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
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: state.outdoorFeatures
                            .where((f) => OutdoorExtra.fromString(f) == null)
                            .map(
                              (feature) => CustomChip(
                                theme: theme,
                                label: feature,
                                onDelete: () =>
                                    viewModel.removeOutdoorFeature(feature),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
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
    );
  }
}
