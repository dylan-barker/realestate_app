import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../controllers/property_controller.dart';

class AddressStep extends ConsumerWidget {
  const AddressStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyControllerProvider);
    final controller = ref.read(propertyControllerProvider.notifier);
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle instruction
          Text(
            'Where is the property?',
            style: textTheme.labelLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start typing the address to auto-populate details.',
            style: textTheme.bodyLarge?.copyWith(
              color: theme.textSecondary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),

          // Google Maps Search Bar
          CustomTextInput(
            label: 'Search address',
            placeholder: 'Search address on Google Maps...',
            keyboardType: TextInputType.streetAddress,
            prefixIcon: Icon(
              Icons.search,
              color: theme.textSecondary,
              size: 20,
            ),
            onChanged: (val) {
              // Simulating auto-completion / updating street address
              controller.updateAddress(streetAddress: val);
            },
          ),
          const SizedBox(height: 24),

          // Verified Address Details Card
          Text(
            'Verified Address Details',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          CustomCard(
            backgroundColor: theme.borderLight.withOpacity(0.3),
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressField(theme, textTheme, 'Street Address', state.streetAddress),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildAddressField(theme, textTheme, 'Suburb / District', state.suburb),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildAddressField(theme, textTheme, 'City', state.city),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildAddressField(theme, textTheme, 'Province / State', state.province),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildAddressField(theme, textTheme, 'Postal Code', state.postalCode),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Additional Identifiers Card
          Text(
            'Additional Identifiers',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          CustomCard(
            backgroundColor: theme.borderLight.withOpacity(0.3),
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextInput(
                  label: 'Complex / Estate Name (Optional)',
                  placeholder: 'e.g. Skyline Towers',
                  initialValue: state.complexName,
                  onChanged: (val) => controller.updateIdentifiers(complexName: val),
                ),
                const SizedBox(height: 16),
                CustomTextInput(
                  label: 'Erf / Plot Number',
                  placeholder: 'Enter registration number',
                  initialValue: state.erfPlotNumber,
                  subtext: 'Found on municipal rates bill or property deed.',
                  onChanged: (val) => controller.updateIdentifiers(erfPlotNumber: val),
                ),
              ],
            ),
          ),
        ],
      ),
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
            color: theme.textLabel.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '—' : value,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }
}
