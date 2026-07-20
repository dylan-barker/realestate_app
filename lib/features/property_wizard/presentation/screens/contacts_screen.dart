import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/wizard_app_bar.dart';
import '../../providers/property_provider.dart';
import '../widgets/contact_card.dart';

class ContactsStep extends ConsumerWidget {
  const ContactsStep({super.key});

  Future<void> _saveAndPop(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    await viewModel.saveContacts();
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeConfigProvider);
    final textTheme = theme.toThemeData().textTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: WizardAppBar(
        title: 'Contacts',
        onBack: () => _saveAndPop(context, ref),
        theme: theme,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter the primary contact and co-contacts for this listing.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact Information',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => viewModel.addCoContact(),
                    icon: Icon(
                      Icons.add_circle,
                      color: theme.primaryColor,
                      size: 16,
                    ),
                    label: Text(
                      'Add Co-Contact',
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
              ContactCard(
                theme: theme,
                textTheme: textTheme,
                contact: state.primaryContact,
                label: 'Primary Contact',
                showRemove: false,
                onChanged: (contact) => viewModel.updatePrimaryContact(contact),
              ),
              ...state.coContacts.asMap().entries.map((entry) {
                final index = entry.key;
                final coContact = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ContactCard(
                    theme: theme,
                    textTheme: textTheme,
                    contact: coContact,
                    label: 'Co-Contact ${index + 1}',
                    showRemove: true,
                    onChanged: (contact) =>
                        viewModel.updateCoContact(index, contact),
                    onRemove: () => viewModel.removeCoContact(coContact.id),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
