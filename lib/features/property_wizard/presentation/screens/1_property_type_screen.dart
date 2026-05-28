import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../widgets/wizard_footer.dart';
import '../../data/models/enums/property_subtype.dart';
import '../../data/models/enums/property_type.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../application/providers/property_provider.dart';
import '../../application/providers/wizard_navigation_provider.dart';

class PropertyTypeStep extends ConsumerWidget {
  const PropertyTypeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;
    final navData = ref.watch(wizardNavigationProvider);

    final types = [
      {'type': PropertyType.house, 'icon': Icons.home_outlined},
      {'type': PropertyType.townhouse, 'icon': Icons.business_outlined},
      {'type': PropertyType.apartment, 'icon': Icons.corporate_fare_outlined},
      {'type': PropertyType.vacantLand, 'icon': Icons.terrain_outlined},
      {'type': PropertyType.plot, 'icon': Icons.grid_view_outlined},
    ];

    final subtypes = PropertySubtype.values;

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
                Text('K', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 22, color: theme.textPrimary)),
                Text('W', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 22, color: theme.primaryColor)),
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
                'What type of property is this?',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 24),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(itemIcon, size: 26, color: isSelected ? theme.primaryColor : theme.textPrimary.withOpacity(0.6)),
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
                    label: subtype.displayString,
                    isSelected: isSelected,
                    onTap: () => viewModel.selectPropertySubtype(subtype),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WizardFooter(
        onNext: () {
          viewModel.nextStep();
          context.push(PropertyWizardStep.address.routePath);
        },
      ),
    );
  }
}
