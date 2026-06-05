import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/wizard_app_bar.dart';
import '../../../../core/widgets/wizard_header.dart';
import '../../data/models/enums/architectural_style.dart';
import '../../data/models/enums/facing_direction.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../data/models/enums/roof_configuration.dart';
import '../../data/models/enums/wall_exterior.dart';
import '../../providers/property_provider.dart';
import '../../providers/wizard_navigation_provider.dart';
import '../widgets/wizard_footer.dart';

class BuildingInfoStep extends ConsumerWidget {
  const BuildingInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;
    final navData = ref.watch(wizardNavigationProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: WizardAppBar(
        title: navData.headerTitle,
        onBack: () {
          viewModel.prevStep();
          context.pop();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WizardHeader(
                progressLabel: navData.progressLabel,
                title: 'Physical Blueprint',
                description: 'Provide the core structural specifications of the property for valuation and regulatory compliance.',
              ),
              const SizedBox(height: 28),
              CustomTextInput(
                theme: theme,
                label: 'Erf Size (m\u00B2)',
                placeholder: '0.00',
                initialValue: state.erfSize,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => viewModel.updateTechnicalSpecs(erfSize: val),
              ),
              const SizedBox(height: 18),
              CustomTextInput(
                theme: theme,
                label: 'Floor Area (m\u00B2)',
                placeholder: '0.00',
                initialValue: state.floorArea,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => viewModel.updateTechnicalSpecs(floorArea: val),
              ),
              const SizedBox(height: 18),
              CustomTextInput(
                theme: theme,
                label: 'Construction Year',
                placeholder: 'YYYY',
                initialValue: state.constructionYear,
                keyboardType: TextInputType.number,
                onChanged: (val) => viewModel.updateTechnicalSpecs(constructionYear: val),
              ),
              const SizedBox(height: 18),
              CustomTextInput(
                theme: theme,
                label: 'Max Height (m)',
                placeholder: '0.00',
                initialValue: state.maxHeight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => viewModel.updateTechnicalSpecs(maxHeight: val),
              ),
              const SizedBox(height: 18),
              CustomTextInput(
                theme: theme,
                label: 'Zoning Classification',
                placeholder: 'e.g. Residential 1',
                initialValue: state.zoning,
                onChanged: (val) => viewModel.updateTechnicalSpecs(zoning: val),
              ),
              const SizedBox(height: 28),
              _buildChipSelector<FacingDirection>(
                theme: theme,
                textTheme: textTheme,
                label: 'Facing Direction',
                options: FacingDirection.values,
                selectedOption: state.facingDirection,
                getLabel: (opt) => opt.displayString,
                onSelected: (val) => viewModel.selectFacingDirection(val),
              ),
              const SizedBox(height: 24),
              _buildChipSelector<ArchitecturalStyle>(
                theme: theme,
                textTheme: textTheme,
                label: 'Architectural Style',
                options: ArchitecturalStyle.values,
                selectedOption: state.architecturalStyle,
                getLabel: (opt) => opt.displayString,
                onSelected: (val) => viewModel.selectArchitecturalStyle(val),
              ),
              const SizedBox(height: 24),
              _buildChipSelector<RoofConfiguration>(
                theme: theme,
                textTheme: textTheme,
                label: 'Roof Configuration',
                options: RoofConfiguration.values,
                selectedOption: state.roofConfiguration,
                getLabel: (opt) => opt.displayString,
                onSelected: (val) => viewModel.selectRoofConfiguration(val),
              ),
              const SizedBox(height: 24),
              _buildChipSelector<WallExterior>(
                theme: theme,
                textTheme: textTheme,
                label: 'Wall Exterior',
                options: WallExterior.values,
                selectedOption: state.wallExterior,
                getLabel: (opt) => opt.displayString,
                onSelected: (val) => viewModel.selectWallExterior(val),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WizardFooter(
        onNext: () {
          viewModel.nextStep();
          context.push(PropertyWizardStep.propertyFeatures.routePath);
        },
        onBack: () {
          viewModel.prevStep();
          context.pop();
        },
      ),
    );
  }

  Widget _buildChipSelector<T>({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required String label,
    required List<T> options,
    required T selectedOption,
    required String Function(T) getLabel,
    required ValueChanged<T> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 10.0,
          children: options.map((opt) {
            final isSelected = selectedOption == opt;
            return CustomChip(
              theme: theme,
              label: getLabel(opt),
              isSelected: isSelected,
              onTap: () => onSelected(opt),
            );
          }).toList(),
        ),
      ],
    );
  }
}
