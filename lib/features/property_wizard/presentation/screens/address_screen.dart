import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/wizard_scaffold.dart';
import '../../providers/property_provider.dart';
import '../widgets/wizard_actions.dart';

class AddressStep extends ConsumerWidget {
  const AddressStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;

    return WizardScaffold(
      title: 'Where is the property?',
      description: 'Start typing the address to auto-populate details.',
      onBack: () => goBackWizard(context, ref),
      onNext: () => advanceWizard(context, ref),
      children: [
        CustomTextInput(
          theme: theme,
          label: 'Search address',
          placeholder: 'Search address...',
          keyboardType: TextInputType.streetAddress,
          prefixIcon: Icon(Icons.search, color: theme.textSecondary, size: 20),
          onChanged: (val) => viewModel.updateAddress(streetAddress: val),
        ),
        const SizedBox(height: 24),
        Text(
          'Verified Address Details',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          theme: theme,
          backgroundColor: theme.borderLight.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddressField(
                theme,
                textTheme,
                'Street Address',
                state.streetAddress,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildAddressField(
                      theme,
                      textTheme,
                      'Suburb / District',
                      state.suburb,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAddressField(
                      theme,
                      textTheme,
                      'City',
                      state.city,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildAddressField(
                      theme,
                      textTheme,
                      'Province / State',
                      state.province,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAddressField(
                      theme,
                      textTheme,
                      'Postal Code',
                      state.postalCode,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Additional Identifiers',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          theme: theme,
          backgroundColor: theme.borderLight.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInput(
                theme: theme,
                label: 'Complex / Estate Name (Optional)',
                placeholder: 'e.g. Skyline Towers',
                initialValue: state.complexName,
                onChanged: (val) =>
                    viewModel.updateIdentifiers(complexName: val),
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                theme: theme,
                label: 'Erf / Plot Number',
                placeholder: 'Enter registration number',
                initialValue: state.erfPlotNumber,
                subtext: 'Found on municipal rates bill or property deed.',
                onChanged: (val) =>
                    viewModel.updateIdentifiers(erfPlotNumber: val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField(
    RealEstateTheme theme,
    TextTheme textTheme,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: theme.textLabel.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '\u2014' : value,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }
}
