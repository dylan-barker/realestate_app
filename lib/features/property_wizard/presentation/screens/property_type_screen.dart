import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/wizard_scaffold.dart';
import '../../data/models/enums/property_subtype.dart';
import '../../data/models/enums/property_type.dart';
import '../../providers/property_provider.dart';
import '../widgets/wizard_actions.dart';

class PropertyTypeStep extends ConsumerWidget {
  const PropertyTypeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;

    final types = [
      {'type': PropertyType.house, 'icon': Icons.home_outlined},
      {'type': PropertyType.townhouse, 'icon': Icons.business_outlined},
      {'type': PropertyType.apartment, 'icon': Icons.corporate_fare_outlined},
      {'type': PropertyType.vacantLand, 'icon': Icons.terrain_outlined},
      {'type': PropertyType.plot, 'icon': Icons.grid_view_outlined},
    ];

    final subtypes = PropertySubtype.values;

    return WizardScaffold(
      title: 'What type of property is this?',
      onBack: () => goBackWizard(context, ref),
      onNext: () => advanceWizard(context, ref),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.35,
          ),
          itemCount: types.length,
          itemBuilder: (context, index) {
            final item = types[index];
            final itemType = item['type'] as PropertyType;
            final itemIcon = item['icon'] as IconData;
            final isSelected = state.propertyType == itemType;
            return CustomCard(
              theme: theme,
              isSelected: isSelected,
              onTap: () => viewModel.selectPropertyType(itemType),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    itemIcon,
                    size: 26,
                    color: isSelected
                        ? theme.primaryColor
                        : theme.textPrimary.withValues(alpha: 0.6),
                  ),
                  Text(
                    itemType.displayString,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          'Refine the subtype',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 10.0,
          children: subtypes.map((subtype) {
            final isSelected = state.propertySubtype == subtype;
            return CustomChip(
              theme: theme,
              label: subtype.displayString,
              isSelected: isSelected,
              onTap: () => viewModel.selectPropertySubtype(subtype),
            );
          }).toList(),
        ),
      ],
    );
  }
}
