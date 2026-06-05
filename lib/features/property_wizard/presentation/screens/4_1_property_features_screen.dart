import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../data/models/enums/room_category.dart';
import '../../data/models/outdoor_extra_item.dart';
import '../../data/models/room.dart';
import '../../providers/property_provider.dart';
import '../../providers/wizard_navigation_provider.dart';
import '../widgets/wizard_footer.dart';

class PropertyFeaturesStep extends ConsumerWidget {
  const PropertyFeaturesStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;
    final navData = ref.watch(wizardNavigationProvider);

    final categories = RoomCategory.values;

    Map<RoomCategory, List<Room>> groupedRooms = {
      for (var cat in categories) cat: [],
    };
    for (var room in state.rooms) {
      if (groupedRooms.containsKey(room.type)) {
        groupedRooms[room.type]!.add(room);
      }
    }

    final outdoorCategories = OutdoorExtraCategory.values;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.textPrimary,
            size: 20,
          ),
          onPressed: () {
            viewModel.prevStep();
            context.pop();
          },
        ),
        centerTitle: true,
        title: Text(
          navData.headerTitle,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'K',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: theme.textPrimary,
                  ),
                ),
                Text(
                  'W',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: theme.borderLight, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                navData.progressLabel.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Property Features',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Detail and configure every room in the residence.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.textSecondary.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 28),
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
                _buildRoomSection(
                  context,
                  theme,
                  textTheme,
                  category,
                  groupedRooms[category]!,
                  viewModel,
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 20),
              Container(height: 1, color: theme.borderLight),
              const SizedBox(height: 20),
              Text(
                'OUTDOOR & EXTRAS',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textLabel,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              for (var outdoorCat in outdoorCategories) ...[
                _buildOutdoorSubcategory(
                  theme,
                  textTheme,
                  outdoorCat,
                  state.outdoorExtras,
                  viewModel,
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddOutdoorDialog(
                    context, viewModel, theme, textTheme,
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  label: const Text('Add Custom Outdoor / Extra Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.textLabel,
                    elevation: 0,
                    side: BorderSide(
                      color: theme.borderLight,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WizardFooter(
        onNext: () {
          viewModel.nextStep();
          context.push(PropertyWizardStep.mandateContacts.routePath);
        },
        onBack: () {
          viewModel.prevStep();
          context.pop();
        },
      ),
    );
  }

  Widget _buildRoomSection(
    BuildContext context,
    RealEstateTheme theme,
    TextTheme textTheme,
    RoomCategory category,
    List<Room> rooms,
    PropertyViewModel viewModel,
  ) {
    final hasRooms = rooms.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderLight),
      ),
      child: ExpansionTile(
        initiallyExpanded: hasRooms,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Row(
          children: [
            Expanded(
              child: Text(
                category.displayString,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
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
            const SizedBox(width: 8),
          ],
        ),
        children: [
          if (!hasRooms) ...[
            const SizedBox(height: 4),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No rooms added yet.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.textSecondary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: _buildAddButton(
                context, theme, textTheme, category, viewModel,
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
                      context.push('/wizard/room-details/${room.id}');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.backgroundColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.borderLight.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    if (room.description.isNotEmpty) ...[
                                      Text(
                                        room.description,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: theme.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '•',
                                        style: TextStyle(
                                          color: theme.textSecondary.withOpacity(
                                            0.5,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      room.isComplete ? 'COMPLETE' : 'PENDING',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: room.isComplete
                                            ? theme.completeColor
                                            : theme.pendingColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _confirmDeleteRoom(
                              context,
                              viewModel,
                              room,
                              theme,
                              textTheme,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.borderLight.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
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
                            color: theme.textSecondary.withOpacity(0.5),
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
              child: _buildAddButton(
                context, theme, textTheme, category, viewModel,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    RealEstateTheme theme,
    TextTheme textTheme,
    RoomCategory category,
    PropertyViewModel viewModel,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _showAddRoomDialog(
        context, viewModel, category, theme, textTheme,
      ),
      icon: const Icon(Icons.add, size: 20),
      label: const Text('Add Room'),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildOutdoorSubcategory(
    RealEstateTheme theme,
    TextTheme textTheme,
    OutdoorExtraCategory outdoorCat,
    List<OutdoorExtraItem> selectedItems,
    PropertyViewModel viewModel,
  ) {
    final predefinedInCategory = OutdoorExtra.values
        .where((e) => e.category == outdoorCat)
        .toList();
    final customInCategory = selectedItems
        .where((item) => item.category == outdoorCat)
        .where(
          (item) =>
              !predefinedInCategory.any((e) => e.displayString == item.name),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          outdoorCat.displayString.toUpperCase(),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textLabel,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ...predefinedInCategory.map((extra) {
              final isSelected = selectedItems.any(
                (item) => item.name == extra.displayString,
              );
              final item = selectedItems
                  .where((item) => item.name == extra.displayString)
                  .firstOrNull;
              return _buildOutdoorChip(
                theme,
                textTheme,
                extra.displayString,
                isSelected,
                item?.quantity ?? 0,
                viewModel,
              );
            }),
            ...customInCategory.map((item) {
              return _buildOutdoorChip(
                theme,
                textTheme,
                item.name,
                true,
                item.quantity,
                viewModel,
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildOutdoorChip(
    RealEstateTheme theme,
    TextTheme textTheme,
    String label,
    bool isSelected,
    int quantity,
    PropertyViewModel viewModel,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? theme.primaryColor : theme.borderLight,
        ),
      ),
      child: isSelected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => viewModel.decrementOutdoorQuantity(label),
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  quantity > 1 ? '$label x$quantity' : label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => viewModel.incrementOutdoorQuantity(label),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => viewModel.removeOutdoorExtra(label),
                  child: Icon(Icons.close, size: 14, color: Colors.white70),
                ),
              ],
            )
          : GestureDetector(
              onTap: () => viewModel.addOutdoorExtra(label),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 14, color: theme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _confirmDeleteRoom(
    BuildContext context,
    PropertyViewModel viewModel,
    Room room,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Remove Room',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to remove "${room.name}"?',
            style: textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.removeRoom(room.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddRoomDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    RoomCategory category,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    final predefined = category.predefinedRoomTypes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        String customName = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add ${category.displayString} Room',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose a room type:',
                    style: textTheme.bodyLarge?.copyWith(
                      color: theme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (predefined.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: predefined.map((type) {
                        return InkWell(
                          onTap: () {
                            viewModel.addCustomRoom(type, category);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.borderLight),
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                            ),
                            child: Text(
                              type,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Divider(color: theme.borderLight)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: textTheme.labelLarge?.copyWith(
                            color: theme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: theme.borderLight)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'Custom Room Name',
                    placeholder: 'e.g. Yoga Studio, Wine Cellar',
                    onChanged: (val) => customName = val,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: theme.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (customName.trim().isNotEmpty) {
                            viewModel.addCustomRoom(
                              customName.trim(),
                              category,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add Custom',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddOutdoorDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String name = '';
    OutdoorExtraCategory selectedCategory = OutdoorExtraCategory.outdoorLiving;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                'Add Outdoor/Extra Item',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextInput(
                    label: 'Item Name',
                    placeholder: 'e.g. Tennis Court, Lapa',
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<OutdoorExtraCategory>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: theme.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.borderLight),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: OutdoorExtraCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.displayString),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedCategory = val);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: theme.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (name.trim().isNotEmpty) {
                      viewModel.addOutdoorExtra(
                        name.trim(),
                        category: selectedCategory,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
