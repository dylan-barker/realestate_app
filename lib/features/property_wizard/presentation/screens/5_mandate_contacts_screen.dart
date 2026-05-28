import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../widgets/wizard_footer.dart';
import '../../data/models/enums/lead_source.dart';
import '../../data/models/enums/mandate_type.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../application/providers/property_provider.dart';
import '../../application/providers/wizard_navigation_provider.dart';

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
                'Mandate Details',
                style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the agreement type for this listing.',
                style: textTheme.bodyMedium?.copyWith(color: theme.textSecondary.withOpacity(0.9)),
              ),
              const SizedBox(height: 28),
              Text('MANDATE TYPE', style: textTheme.labelLarge?.copyWith(color: theme.textLabel, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _buildMandateCard(theme: theme, textTheme: textTheme, title: 'Exclusive', subtitle: 'Sole agency rights for a fixed period', isSelected: state.mandateType == MandateType.exclusive, onTap: () => viewModel.selectMandateType(MandateType.exclusive))),
                const SizedBox(width: 12),
                Expanded(child: _buildMandateCard(theme: theme, textTheme: textTheme, title: 'Open', subtitle: 'Multiple agencies can list', isSelected: state.mandateType == MandateType.open, onTap: () => viewModel.selectMandateType(MandateType.open))),
              ]),
              const SizedBox(height: 28),
              Text('LEAD SOURCE', style: textTheme.labelLarge?.copyWith(color: theme.textLabel, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0, runSpacing: 10.0,
                children: LeadSource.values.map((opt) {
                  return CustomChip(label: opt.displayString, isSelected: state.leadSource == opt, onTap: () => viewModel.selectLeadSource(opt));
                }).toList(),
              ),
              const SizedBox(height: 32),
              Row(children: [
                Icon(Icons.hub, color: theme.primaryColor, size: 24),
                const SizedBox(width: 8),
                Text('3rd Party Integrations', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 8),
              Text('Select external services to sync with this listing.', style: textTheme.bodyMedium?.copyWith(color: theme.textSecondary.withOpacity(0.9))),
              const SizedBox(height: 16),
              _buildIntegrationTile(theme: theme, textTheme: textTheme, title: 'Lightstone', isChecked: state.syncLightstone, onChanged: (val) => viewModel.toggleSyncLightstone(val ?? false)),
              const SizedBox(height: 12),
              _buildIntegrationTile(theme: theme, textTheme: textTheme, title: 'Loom', isChecked: state.syncLoom, onChanged: (val) => viewModel.toggleSyncLoom(val ?? false)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Owner Information', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {},
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add_circle, color: theme.primaryColor, size: 16),
                      const SizedBox(width: 4),
                      Text('Add Co-Owner', style: textTheme.labelLarge?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ]),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: CustomTextInput(label: 'FIRST NAME', placeholder: 'John', initialValue: state.ownerFirstName, style: InputStyle.cardBorder, onChanged: (val) => viewModel.updateOwnerInfo(firstName: val))),
                    const SizedBox(width: 16),
                    Expanded(child: CustomTextInput(label: 'LAST NAME', placeholder: 'Doe', initialValue: state.ownerLastName, style: InputStyle.cardBorder, onChanged: (val) => viewModel.updateOwnerInfo(lastName: val))),
                  ]),
                  const SizedBox(height: 16),
                  CustomTextInput(label: 'EMAIL ADDRESS', placeholder: 'john.doe@example.com', initialValue: state.ownerEmail, keyboardType: TextInputType.emailAddress, onChanged: (val) => viewModel.updateOwnerInfo(email: val)),
                  const SizedBox(height: 16),
                  CustomTextInput(label: 'PHONE NUMBER', placeholder: '+27 82 000 0000', initialValue: state.ownerPhone, keyboardType: TextInputType.phone, onChanged: (val) => viewModel.updateOwnerInfo(phone: val)),
                  const SizedBox(height: 16),
                  CustomTextInput(label: 'ID NUMBER', placeholder: 'Optional', initialValue: state.ownerIdNumber, onChanged: (val) => viewModel.updateOwnerInfo(idNumber: val)),
                ]),
              ),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: _buildDateSelector(theme: theme, textTheme: textTheme, label: 'MANDATE START', value: state.mandateStart ?? '24 Oct 2023', onTap: () {})),
                const SizedBox(width: 16),
                Expanded(child: _buildDateSelector(theme: theme, textTheme: textTheme, label: 'MANDATE END', value: state.mandateEnd ?? 'Select Date', isPlaceholder: state.mandateEnd == null, onTap: () {})),
              ]),
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

  Widget _buildMandateCard({required RealEstateTheme theme, required TextTheme textTheme, required String title, required String subtitle, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : theme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.primaryColor : theme.borderLight, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: theme.primaryColor.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(Icons.verified, color: isSelected ? theme.primaryColor : theme.textSecondary, size: 20),
              Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? theme.primaryColor : theme.borderLight, size: 20),
            ]),
            const SizedBox(height: 12),
            Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.textPrimary)),
            const SizedBox(height: 4),
            Text(subtitle, style: textTheme.bodySmall?.copyWith(color: theme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationTile({required RealEstateTheme theme, required TextTheme textTheme, required String title, required bool isChecked, required ValueChanged<bool?> onChanged}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.borderLight)),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: theme.borderLight),
        child: CheckboxListTile(
          value: isChecked, onChanged: onChanged,
          activeColor: theme.primaryColor, checkColor: Colors.white,
          title: Text(title, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: theme.textPrimary)),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDateSelector({required RealEstateTheme theme, required TextTheme textTheme, required String label, required String value, required VoidCallback onTap, bool isPlaceholder = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: theme.textLabel, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.borderLight)),
            child: Row(children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: isPlaceholder ? theme.textSecondary : theme.primaryColor),
              const SizedBox(width: 12),
              Text(value, style: textTheme.bodyLarge?.copyWith(
                color: isPlaceholder ? theme.textSecondary : theme.textPrimary,
                fontWeight: isPlaceholder ? FontWeight.normal : FontWeight.w600,
              )),
            ]),
          ),
        ),
      ],
    );
  }
}
