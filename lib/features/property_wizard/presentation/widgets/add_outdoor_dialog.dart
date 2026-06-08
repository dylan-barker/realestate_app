import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/real_estate_dialog.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../providers/property_provider.dart';

class AddOutdoorDialog {
  static void show(
    BuildContext context,
    PropertyViewModel viewModel,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String name = '';
    OutdoorExtraCategory selectedCategory = OutdoorExtraCategory.outdoorLiving;

    showRealEstateDialog(
      context: context,
      title: 'Add Outdoor/Extra Item',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                theme: theme,
                label: 'Item Name',
                placeholder: 'e.g. Tennis Court, Lapa',
                onChanged: (val) => name = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<OutdoorExtraCategory>(
                initialValue: selectedCategory,
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
          );
        },
      ),
      actions: [
        dialogCancelButton(context: context, theme: theme),
        dialogActionButton(
          theme: theme,
          text: 'Add',
          onPressed: () {
            if (name.trim().isNotEmpty) {
              viewModel.addOutdoorExtra(
                name.trim(),
                category: selectedCategory,
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
