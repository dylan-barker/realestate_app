// Step 4.2
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../viewmodels/property_view_model.dart';

class RoomDetailsStep extends ConsumerWidget {
  const RoomDetailsStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;

    // Retrieve active editing room details
    final room = state.rooms.firstWhere(
      (r) => r.id == state.selectedRoomId,
      orElse: () => state.rooms.first,
    );

    // Emojis and descriptions list
    final ratings = [
      {'level': 1, 'emoji': '😵', 'label': 'LEVEL 1\nTo be\nrenovated'},
      {'level': 2, 'emoji': '😐', 'label': 'LEVEL 2\nTo be\nrenovated'},
      {'level': 3, 'emoji': '🙂', 'label': 'LEVEL 3\nOptional\nrenovation'},
      {'level': 4, 'emoji': '😀', 'label': 'LEVEL 4\nPerfect\ncondition'},
    ];

    // Standard initial values
    final standardAmenities = [
      'Ceiling Fan',
      'Wall-to-Wall Carpets',
      'Air Conditioning',
      'Built-in Cupboards',
      'En-suite Bathroom',
      'Balcony',
    ];

    final suggestedAmenities = standardAmenities
        .where((amenity) => !room.features.contains(amenity))
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 24.0,
        bottom: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Room Identity
          Text(
            'ROOM IDENTITY',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textLabel,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          CustomCard(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  room.name,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => _showRenameDialog(
                    context,
                    viewModel,
                    room.id,
                    room.name,
                    theme,
                    textTheme,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // High fidelity Room Image/Illustration container
          _buildRoomGraphic(theme, textTheme),
          const SizedBox(height: 28),

          // Section: Room Condition Rating
          Text(
            'Room Condition Rating',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rate the current state of the space.',
            style: textTheme.bodyMedium?.copyWith(color: theme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Condition rating 4 buttons side-by-side
          Row(
            children: ratings.map((rating) {
              final level = rating['level'] as int;
              final emoji = rating['emoji'] as String;
              final label = rating['label'] as String;
              final isSelected = room.conditionRating == level;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CustomCard(
                    isSelected: isSelected,
                    onTap: () => viewModel.updateRoomDetails(
                      roomId: room.id,
                      conditionRating: level,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 10),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: textTheme.labelMedium?.copyWith(
                            fontSize: 9,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? theme.primaryColor
                                : theme.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Section: Features & Amenities
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features & Amenities',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Select all that apply to this space.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2), // Soft red badge
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'REQUIRED',
                  style: textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFEF4444),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of current features with clear buttons
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: room.features.length,
            itemBuilder: (context, index) {
              final feature = room.features[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: CustomChip(
                  label: feature,
                  onDelete: () =>
                      viewModel.removeFeatureFromRoom(room.id, feature),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // + Add Custom Feature Button
          CustomCard(
            hasDashedBorder: true,
            backgroundColor: theme.backgroundColor.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            onTap: () => _showAddFeatureDialog(
              context,
              viewModel,
              room.id,
              theme,
              textTheme,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20, color: theme.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'ADD CUSTOM FEATURE',
                    style: textTheme.bodyLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Suggested Amenities Wrap
          if (suggestedAmenities.isNotEmpty) ...[
            Text(
              'SUGGESTED AMENITIES',
              style: textTheme.labelLarge?.copyWith(
                color: theme.textSecondary,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: suggestedAmenities.map((amenity) {
                return InkWell(
                  onTap: () => viewModel.addFeatureToRoom(room.id, amenity),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.borderLight),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 12, color: theme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          amenity,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: theme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
          ] else
            const SizedBox(height: 28),

          // Section: Room Notes
          Text(
            'ROOM NOTES',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textLabel,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          CustomCard(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      color: theme.textLabel,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ROOM NOTES',
                      style: textTheme.labelLarge?.copyWith(
                        color: theme.textLabel,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: room.notes,
                  maxLines: 4,
                  onChanged: (val) =>
                      viewModel.updateRoomDetails(roomId: room.id, notes: val),
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Add specific details about the condition or layout of this room...',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: theme.textSecondary.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Save / Done Button at the bottom
          CustomButton(
            text: 'Save & Return to Features',
            fullWidth: true,
            onTap: () {
              // Automatically mark as complete if condition selected
              viewModel.selectRoomForEditing(null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoomGraphic(RealEstateTheme theme, TextTheme textTheme) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16.0),
        image: const DecorationImage(
          // Utilizing a high-fidelity placeholder asset illustration using gradients
          image: NetworkImage(
            'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&q=80&w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.bottomLeft,
        child: Text(
          'Premium Interior Architectural Blueprint View',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    String roomId,
    String currentName,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String name = currentName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Rename Room',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: 'Room Name',
                placeholder: 'e.g. Master Bedroom Suite',
                initialValue: currentName,
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
                  viewModel.renameRoom(roomId, name.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddFeatureDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    String roomId,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String feature = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Add Amenity / Feature',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: 'Feature Name',
                placeholder: 'e.g. USB Outlets, Underfloor Heating',
                onChanged: (val) => feature = val,
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
                if (feature.trim().isNotEmpty) {
                  viewModel.addFeatureToRoom(roomId, feature.trim());
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
