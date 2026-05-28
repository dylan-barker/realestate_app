// Step 1
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../domain/enums/property_subtype.dart';
import '../../domain/enums/property_type.dart';
import '../viewmodels/property_view_model.dart';

class PropertyTypeStep extends ConsumerWidget {
  const PropertyTypeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;

    // Property types details using enums
    final types = [
      {'type': PropertyType.house, 'icon': Icons.home_outlined},
      {'type': PropertyType.townhouse, 'icon': Icons.business_outlined},
      {'type': PropertyType.apartment, 'icon': Icons.corporate_fare_outlined},
      {'type': PropertyType.vacantLand, 'icon': Icons.terrain_outlined},
      {'type': PropertyType.plot, 'icon': Icons.grid_view_outlined},
    ];

    // Subtypes lists from enum values
    final subtypes = PropertySubtype.values;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle and Title
          Text(
            'STEP 1 OF 6',
            style: textTheme.labelLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'What type of property is this?',
            style: textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 24),

          // Types Grid (Compact layout, fits single height)
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
                          : theme.textPrimary.withOpacity(0.6),
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

          // Refine section
          Text(
            'Refine the subtype',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Subtypes wrapped list
          Wrap(
            spacing: 8.0,
            runSpacing: 10.0,
            children: subtypes.map((subtype) {
              final isSelected = state.propertySubtype == subtype;
              return CustomChip(
                label: subtype.displayString,
                isSelected: isSelected,
                onTap: () => viewModel.selectPropertySubtype(subtype),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
