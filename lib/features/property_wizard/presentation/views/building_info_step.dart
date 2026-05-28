// Step 3

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../domain/enums/architectural_style.dart';
import '../../domain/enums/facing_direction.dart';
import '../../domain/enums/roof_configuration.dart';
import '../../domain/enums/wall_exterior.dart';
import '../viewmodels/building_info_view_model.dart';

class BuildingInfoStep extends ConsumerWidget {
  const BuildingInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(buildingInfoViewModelProvider);
    final viewModel = ref.read(buildingInfoViewModelProvider.notifier);
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle and Title
          Text(
            'STEP 3 OF 6',
            style: textTheme.labelLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Physical Blueprint',
            style: textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide the core structural specifications of the property for valuation and regulatory compliance.',
            style: textTheme.bodyMedium?.copyWith(
              color: theme.textSecondary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 28),

          // Specifications Inputs Card Framework
          CustomTextInput(
            label: 'Erf Size (m²)',
            placeholder: '0.00',
            initialValue: state.erfSize == '0.00' ? '' : state.erfSize,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (val) => viewModel.updateTechnicalSpecs(erfSize: val),
          ),
          const SizedBox(height: 18),
          CustomTextInput(
            label: 'Floor Area (m²)',
            placeholder: '0.00',
            initialValue: state.floorArea == '0.00' ? '' : state.floorArea,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (val) => viewModel.updateTechnicalSpecs(floorArea: val),
          ),
          const SizedBox(height: 18),
          CustomTextInput(
            label: 'Construction Year',
            placeholder: 'YYYY',
            initialValue: state.constructionYear == 'YYYY'
                ? ''
                : state.constructionYear,
            keyboardType: TextInputType.number,
            onChanged: (val) =>
                viewModel.updateTechnicalSpecs(constructionYear: val),
          ),
          const SizedBox(height: 18),
          CustomTextInput(
            label: 'Max Height (m)',
            placeholder: '0.00',
            initialValue: state.maxHeight == '0.00' ? '' : state.maxHeight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (val) => viewModel.updateTechnicalSpecs(maxHeight: val),
          ),
          const SizedBox(height: 18),
          CustomTextInput(
            label: 'Zoning Classification',
            placeholder: 'e.g. Residential 1',
            initialValue: state.zoning == 'e.g. Residential 1'
                ? ''
                : state.zoning,
            onChanged: (val) => viewModel.updateTechnicalSpecs(zoning: val),
          ),
          const SizedBox(height: 28),

          // Visual Selector Chips: Facing Direction
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

          // Visual Selector Chips: Architectural Style
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

          // Visual Selector Chips: Roof Configuration
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

          // Visual Selector Chips: Wall Exterior
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
