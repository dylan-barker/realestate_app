import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../widgets/wizard_footer.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../application/providers/property_provider.dart';
import '../../application/providers/wizard_navigation_provider.dart';

class AddressStep extends ConsumerWidget {
  const AddressStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;
    final navData = ref.watch(wizardNavigationProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.textPrimary, size: 20),
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
                'Where is the property?',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start typing the address to auto-populate details.',
                style: textTheme.bodyLarge?.copyWith(
                  color: theme.textSecondary.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextInput(
                label: 'Search address',
                placeholder: 'Search address on Google Maps...',
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
                backgroundColor: theme.borderLight.withOpacity(0.3),
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressField(theme, textTheme, 'Street Address', state.streetAddress),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _buildAddressField(theme, textTheme, 'Suburb / District', state.suburb)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildAddressField(theme, textTheme, 'City', state.city)),
                    ]),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _buildAddressField(theme, textTheme, 'Province / State', state.province)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildAddressField(theme, textTheme, 'Postal Code', state.postalCode)),
                    ]),
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
                backgroundColor: theme.borderLight.withOpacity(0.3),
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextInput(
                      label: 'Complex / Estate Name (Optional)',
                      placeholder: 'e.g. Skyline Towers',
                      initialValue: state.complexName,
                      onChanged: (val) => viewModel.updateIdentifiers(complexName: val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextInput(
                      label: 'Erf / Plot Number',
                      placeholder: 'Enter registration number',
                      initialValue: state.erfPlotNumber,
                      subtext: 'Found on municipal rates bill or property deed.',
                      onChanged: (val) => viewModel.updateIdentifiers(erfPlotNumber: val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WizardFooter(
        onNext: () {
          viewModel.nextStep();
          context.push(PropertyWizardStep.buildingInfo.routePath);
        },
        onBack: () {
          viewModel.prevStep();
          context.pop();
        },
      ),
    );
  }

  Widget _buildAddressField(RealEstateTheme theme, TextTheme textTheme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: theme.textLabel.withOpacity(0.8), fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '—' : value,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.textPrimary),
        ),
      ],
    );
  }
}
