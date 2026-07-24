import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/real_estate_dialog.dart';
import '../../../../core/widgets/wizard_app_bar.dart';
import '../../providers/property_provider.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _errors = <String, String?>{};

  bool _validate(String street, String city, String country) {
    _errors.clear();
    if (street.trim().isEmpty) _errors['street'] = 'Street name is required';
    if (city.trim().isEmpty) _errors['city'] = 'City is required';
    if (country.trim().isEmpty) _errors['country'] = 'Country is required';
    setState(() {});
    return _errors.isEmpty;
  }

  Future<void> _saveAndPop() async {
    final state = ref.read(propertyViewModelProvider);
    if (!_validate(state.street, state.city, state.country)) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    await viewModel.saveAddress();
    if (context.mounted) Navigator.pop(context);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeConfigProvider);
    final textTheme = theme.toThemeData().textTheme;

    _errors.removeWhere((k, v) {
      if (k == 'street') return state.street.trim().isNotEmpty;
      if (k == 'city') return state.city.trim().isNotEmpty;
      if (k == 'country') return state.country.trim().isNotEmpty;
      return true;
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await showDiscardDialog(context);
        if (discard == true) {
          context.pop();
          return;
        }
        await _saveAndPop();
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: WizardAppBar(
          title: 'Address',
          onBack: () => Navigator.maybePop(context),
          theme: theme,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where is the property?',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter the property address details.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Street Address',
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextInput(
                                theme: theme,
                                label: 'Street Number',
                                placeholder: '',
                                initialValue: state.streetNumber,
                                onChanged: (val) =>
                                    viewModel.updateAddress(streetNumber: val),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextInput(
                                theme: theme,
                                label: 'Unit Number (Optional)',
                                placeholder: '',
                                initialValue: state.unitNumber,
                                onChanged: (val) =>
                                    viewModel.updateAddress(unitNumber: val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomTextInput(
                          theme: theme,
                          label: 'Street Name',
                          placeholder: '',
                          initialValue: state.street,
                          autofillHints: const [
                            AutofillHints.streetAddressLevel1,
                          ],
                          errorText: _errors['street'],
                          onChanged: (val) =>
                              viewModel.updateAddress(street: val),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextInput(
                                theme: theme,
                                label: 'Suburb / District',
                                placeholder: '',
                                initialValue: state.suburb,
                                onChanged: (val) =>
                                    viewModel.updateAddress(suburb: val),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextInput(
                                theme: theme,
                                label: 'City',
                                placeholder: '',
                                initialValue: state.city,
                                errorText: _errors['city'],
                                onChanged: (val) =>
                                    viewModel.updateAddress(city: val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextInput(
                                theme: theme,
                                label: 'Province / State',
                                placeholder: '',
                                initialValue: state.province,
                                onChanged: (val) =>
                                    viewModel.updateAddress(province: val),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextInput(
                                theme: theme,
                                label: 'Country',
                                placeholder: '',
                                initialValue: state.country,
                                autofillHints: const [
                                  AutofillHints.countryName,
                                ],
                                errorText: _errors['country'],
                                onChanged: (val) =>
                                    viewModel.updateAddress(country: val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomTextInput(
                          theme: theme,
                          label: 'Postal Code',
                          placeholder: '',
                          initialValue: state.postalCode,
                          autofillHints: const [AutofillHints.postalCode],
                          onChanged: (val) =>
                              viewModel.updateAddress(postalCode: val),
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
                          label: 'Estate Name (Optional)',
                          placeholder: '',
                          initialValue: state.estateName,
                          onChanged: (val) =>
                              viewModel.updateIdentifiers(estateName: val),
                        ),
                        const SizedBox(height: 16),
                        CustomTextInput(
                          theme: theme,
                          label: 'Erf Number',
                          placeholder: '',
                          initialValue: state.erfNumber,
                          subtext:
                              'Found on municipal rates bill or property deed.',
                          onChanged: (val) =>
                              viewModel.updateIdentifiers(erfNumber: val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
