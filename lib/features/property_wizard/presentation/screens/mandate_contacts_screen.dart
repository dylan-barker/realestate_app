import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_date_selector.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../../../core/widgets/wizard_app_bar.dart';
import '../../../../core/widgets/wizard_header.dart';
import '../../data/models/enums/entity_type.dart';
import '../../data/models/enums/lead_source.dart';
import '../../data/models/enums/mandate_type.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../data/models/owner.dart';
import '../../providers/property_provider.dart';
import '../../providers/wizard_navigation_provider.dart';
import '../widgets/wizard_footer.dart';

class MandateContactsStep extends ConsumerWidget {
  const MandateContactsStep({super.key});

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
                title: 'Mandate Details',
                description: 'Select the agreement type for this listing.',
              ),
              const SizedBox(height: 28),
              Text(
                'MANDATE TYPE',
                style: textTheme.labelLarge?.copyWith(
                  color: theme.textLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMandateCard(
                      theme: theme,
                      textTheme: textTheme,
                      title: 'Exclusive',
                      subtitle: 'Sole agency rights for a fixed period',
                      isSelected: state.mandateType == MandateType.exclusive,
                      onTap: () =>
                          viewModel.selectMandateType(MandateType.exclusive),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMandateCard(
                      theme: theme,
                      textTheme: textTheme,
                      title: 'Open',
                      subtitle: 'Multiple agencies can list',
                      isSelected: state.mandateType == MandateType.open,
                      onTap: () =>
                          viewModel.selectMandateType(MandateType.open),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'LEAD SOURCE',
                style: textTheme.labelLarge?.copyWith(
                  color: theme.textLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 10.0,
                children: LeadSource.values.map((opt) {
                  return CustomChip(
                    theme: theme,
                    label: opt.displayString,
                    isSelected: state.leadSource == opt,
                    onTap: () => viewModel.selectLeadSource(opt),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Icon(Icons.hub, color: theme.primaryColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '3rd Party Integrations',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Select external services to sync with this listing.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.textSecondary.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 16),
              _buildIntegrationTile(
                theme: theme,
                textTheme: textTheme,
                title: 'Lightstone',
                isChecked: state.syncLightstone,
                onChanged: (val) =>
                    viewModel.toggleSyncLightstone(val ?? false),
              ),
              const SizedBox(height: 12),
              _buildIntegrationTile(
                theme: theme,
                textTheme: textTheme,
                title: 'Loom',
                isChecked: state.syncLoom,
                onChanged: (val) => viewModel.toggleSyncLoom(val ?? false),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Owner Information',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => viewModel.addCoOwner(),
                    icon: Icon(
                      Icons.add_circle,
                      color: theme.primaryColor,
                      size: 16,
                    ),
                    label: Text(
                      'Add Co-Owner',
                      style: textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildOwnerCard(
                theme: theme,
                textTheme: textTheme,
                owner: state.primaryOwner,
                label: 'Primary Owner',
                showRemove: false,
                onChanged: (owner) => viewModel.updatePrimaryOwner(owner),
              ),
              ...state.coOwners.asMap().entries.map((entry) {
                final index = entry.key;
                final coOwner = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildOwnerCard(
                    theme: theme,
                    textTheme: textTheme,
                    owner: coOwner,
                    label: 'Co-Owner ${index + 1}',
                    showRemove: true,
                    onChanged: (owner) =>
                        viewModel.updateCoOwner(index, owner),
                    onRemove: () => viewModel.removeCoOwner(coOwner.id),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomDateSelector(
                      theme: theme,
                      label: 'MANDATE START',
                      value: state.mandateStart,
                      onDateSelected: (date) =>
                          viewModel.updateMandateDates(start: date),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomDateSelector(
                      theme: theme,
                      label: 'MANDATE END',
                      value: state.mandateEnd,
                      onDateSelected: (date) =>
                          viewModel.updateMandateDates(end: date),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WizardFooter(
        onNext: () {
          viewModel.nextStep();
          context.push(PropertyWizardStep.review.routePath);
        },
        onBack: () {
          viewModel.prevStep();
          context.pop();
        },
      ),
    );
  }

  Widget _buildOwnerCard({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required Owner owner,
    required String label,
    required bool showRemove,
    required ValueChanged<Owner> onChanged,
    VoidCallback? onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: theme.textLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showRemove)
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEntityTypeChip(
                  theme: theme,
                  textTheme: textTheme,
                  label: 'Person',
                  isSelected: owner.entityType == EntityType.person,
                  onTap: () => onChanged(owner.copyWith(
                    entityType: EntityType.person,
                    firstName: '',
                    lastName: '',
                    companyName: '',
                    idNumber: '',
                    registrationNumber: '',
                  )),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEntityTypeChip(
                  theme: theme,
                  textTheme: textTheme,
                  label: 'Business',
                  isSelected: owner.entityType == EntityType.business,
                  onTap: () => onChanged(owner.copyWith(
                    entityType: EntityType.business,
                    firstName: '',
                    lastName: '',
                    companyName: '',
                    idNumber: '',
                    registrationNumber: '',
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (owner.entityType == EntityType.person)
            _buildPersonFields(
              theme: theme,
              textTheme: textTheme,
              owner: owner,
              onChanged: onChanged,
            )
          else
            _buildBusinessFields(
              theme: theme,
              textTheme: textTheme,
              owner: owner,
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }

  Widget _buildPersonFields({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required Owner owner,
    required ValueChanged<Owner> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextInput(
                theme: theme,
                label: 'FIRST NAME',
                placeholder: 'John',
                initialValue: owner.firstName,
                style: InputStyle.cardBorder,
                onChanged: (val) =>
                    onChanged(owner.copyWith(firstName: val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextInput(
                theme: theme,
                label: 'LAST NAME',
                placeholder: 'Doe',
                initialValue: owner.lastName,
                style: InputStyle.cardBorder,
                onChanged: (val) =>
                    onChanged(owner.copyWith(lastName: val)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'EMAIL ADDRESS',
          placeholder: 'john.doe@example.com',
          initialValue: owner.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => onChanged(owner.copyWith(email: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'PHONE NUMBER',
          placeholder: '+27 82 000 0000',
          initialValue: owner.phone,
          keyboardType: TextInputType.phone,
          onChanged: (val) => onChanged(owner.copyWith(phone: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'ID NUMBER',
          placeholder: 'Optional',
          initialValue: owner.idNumber,
          onChanged: (val) => onChanged(owner.copyWith(idNumber: val)),
        ),
      ],
    );
  }

  Widget _buildBusinessFields({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required Owner owner,
    required ValueChanged<Owner> onChanged,
  }) {
    return Column(
      children: [
        CustomTextInput(
          theme: theme,
          label: 'COMPANY NAME',
          placeholder: 'Acme Properties Pty Ltd',
          initialValue: owner.companyName,
          style: InputStyle.cardBorder,
          onChanged: (val) =>
              onChanged(owner.copyWith(companyName: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'EMAIL ADDRESS',
          placeholder: 'info@acmeproperties.com',
          initialValue: owner.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => onChanged(owner.copyWith(email: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'PHONE NUMBER',
          placeholder: '+27 82 000 0000',
          initialValue: owner.phone,
          keyboardType: TextInputType.phone,
          onChanged: (val) => onChanged(owner.copyWith(phone: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'REGISTRATION NUMBER',
          placeholder: 'Optional',
          initialValue: owner.registrationNumber,
          onChanged: (val) =>
              onChanged(owner.copyWith(registrationNumber: val)),
        ),
      ],
    );
  }

  Widget _buildEntityTypeChip({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withValues(alpha: 0.1) : theme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? theme.primaryColor : theme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMandateCard({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : theme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.verified,
                  color: isSelected ? theme.primaryColor : theme.textSecondary,
                  size: 20,
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? theme.primaryColor : theme.borderLight,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(color: theme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationTile({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required String title,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderLight),
      ),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: theme.borderLight),
        child: CheckboxListTile(
          value: isChecked,
          onChanged: onChanged,
          activeColor: theme.primaryColor,
          checkColor: Colors.white,
          title: Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.textPrimary,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
