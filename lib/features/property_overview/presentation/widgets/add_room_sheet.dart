import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/real_estate_dialog.dart';
import '../../data/models/enums/room_category.dart';
import '../../providers/property_provider.dart';

class AddRoomSheet {
  static void show(
    BuildContext context,
    PropertyViewModel viewModel,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    showRealEstateBottomSheet(
      context: context,
      theme: theme,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Room',
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
                    // Unified grouped list: all predefined types organised by
                    // category headings but inside a single sheet.
                    ...RoomCategory.values.map((category) {
                      final types = category.predefinedRoomTypes;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.displayString,
                              style: textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: types.map((type) {
                                return InkWell(
                                  onTap: () {
                                    viewModel.addCustomRoom(
                                      type,
                                      category.index + 1,
                                    );
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.borderLight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      color: theme.cardBackgroundColor,
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
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
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
                      theme: theme,
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
                                RoomCategoryExtension.roomTypeIdForType(
                                  customName.trim(),
                                ),
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
                          child: Text(
                            'Add Custom',
                            style: TextStyle(color: theme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
