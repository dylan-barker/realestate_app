import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../data/models/outdoor_extra_item.dart';
import '../../providers/property_provider.dart';
import 'outdoor_chip.dart';

class OutdoorSubcategory extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final OutdoorExtraCategory outdoorCat;
  final List<OutdoorExtraItem> selectedItems;
  final PropertyViewModel viewModel;

  const OutdoorSubcategory({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.outdoorCat,
    required this.selectedItems,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
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
              return OutdoorChip(
                theme: theme,
                textTheme: textTheme,
                label: extra.displayString,
                isSelected: isSelected,
                quantity: item?.quantity ?? 0,
                viewModel: viewModel,
              );
            }),
            ...customInCategory.map((item) {
              return OutdoorChip(
                theme: theme,
                textTheme: textTheme,
                label: item.name,
                isSelected: true,
                quantity: item.quantity,
                viewModel: viewModel,
              );
            }),
          ],
        ),
      ],
    );
  }
}
