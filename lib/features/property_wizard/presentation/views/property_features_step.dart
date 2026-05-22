// Step 4.1
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../data/models/room_model.dart';
import '../controllers/property_controller.dart';

class PropertyFeaturesStep extends ConsumerWidget {
  const PropertyFeaturesStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyControllerProvider);
    final controller = ref.read(propertyControllerProvider.notifier);
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;

    // Categories we support
    final categories = ['Bedrooms', 'Living & Dining', 'Bathrooms & Powder'];

    // Group rooms by category
    Map<String, List<RoomModel>> groupedRooms = {
      for (var cat in categories) cat: [],
    };
    for (var room in state.rooms) {
      if (groupedRooms.containsKey(room.type)) {
        groupedRooms[room.type]!.add(room);
      } else {
        // Fallback for custom categories
        groupedRooms[room.type] = [room];
      }
    }

    // Standard outdoor list options
    final outdoorOptions = [
      'Swimming Pool',
      '3-Car Garage',
      'Patio / Deck',
      'Fireplace',
    ];

    // Combine standard and any custom added outdoor extras
    final allOutdoorOptions = Set<String>.from(outdoorOptions)
      ..addAll(state.outdoorExtras);

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 24.0,
            bottom: 80.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle and Title
              Text(
                'STEP 4 OF 6',
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

              // Loop through categories
              for (var category in categories) ...[
                Text(
                  category.toUpperCase(),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textLabel,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // List of rooms in this category
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groupedRooms[category]!.length,
                  itemBuilder: (context, idx) {
                    final room = groupedRooms[category]![idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: CustomCard(
                        onTap: () {
                          // Select room and enter Step 4.2 Room Details view
                          controller.selectRoomForEditing(room.id);
                        },
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
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
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        room.description,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: theme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '•',
                                        style: TextStyle(
                                          color: theme.textSecondary
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        room.isComplete
                                            ? 'COMPLETE'
                                            : 'PENDING',
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
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: theme.textSecondary.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
              ],

              // + Add Room Button (Dashed border)
              CustomCard(
                hasDashedBorder: true,
                backgroundColor: theme.backgroundColor.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                onTap: () =>
                    _showAddRoomDialog(context, controller, theme, textTheme),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: theme.textLabel,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Room',
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.textLabel,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Outdoor & Extras section
              Text(
                'OUTDOOR & EXTRAS',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textLabel,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8.0,
                runSpacing: 10.0,
                children: allOutdoorOptions.map((opt) {
                  final isSelected = state.outdoorExtras.contains(opt);
                  return CustomChip(
                    label: opt,
                    isSelected: isSelected,
                    onTap: () => controller.toggleOutdoorExtra(opt),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // + Add Outdoor/Extra Button (Dashed border)
              CustomCard(
                hasDashedBorder: true,
                backgroundColor: theme.backgroundColor.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                onTap: () => _showAddOutdoorDialog(
                  context,
                  controller,
                  theme,
                  textTheme,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: theme.textLabel,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Outdoor/Extra Item',
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.textLabel,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Floating Capsule Badge "Step 4 of 6"
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Dark zinc/black capsule
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Step 4 of 6',
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddRoomDialog(
    BuildContext context,
    PropertyController controller,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String name = '';
    String category = 'Bedrooms';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
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
                    'Add Custom Room',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category selector dropdown
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: InputDecoration(
                      labelText: 'Room Category',
                      labelStyle: textTheme.labelLarge?.copyWith(
                        color: theme.textLabel,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: theme.borderLight),
                      ),
                    ),
                    items: ['Bedrooms', 'Living & Dining', 'Bathrooms & Powder']
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => category = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextInput(
                    label: 'Room Name',
                    placeholder: 'e.g. Guest Bedroom 2, Study Office',
                    onChanged: (val) => name = val,
                  ),
                  const SizedBox(height: 24),

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
                          if (name.trim().isNotEmpty) {
                            controller.addCustomRoom(name.trim(), category);
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
                          'Add',
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
    PropertyController controller,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Add Outdoor/Extra Item',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: 'Item Name',
                placeholder: 'e.g. Tennis Court, Lapa',
                onChanged: (val) => name = val,
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
                  controller.addCustomOutdoorExtra(name.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
