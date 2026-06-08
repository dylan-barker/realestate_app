import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_date_selector.dart';
import '../../../../core/widgets/wizard_scaffold.dart';
import '../../data/models/enums/lead_source.dart';
import '../../data/models/enums/mandate_type.dart';
import '../../providers/property_provider.dart';
import '../widgets/integration_tile.dart';
import '../widgets/mandate_card.dart';
import '../widgets/owner_card.dart';
import '../widgets/wizard_actions.dart';

class MandateContactsStep extends ConsumerWidget {
  const MandateContactsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;

    return WizardScaffold(
      title: 'Mandate Details',
      description: 'Select the agreement type for this listing.',
      onBack: () => goBackWizard(context, ref),
      onNext: () => advanceWizard(context, ref),
      children: [
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
              child: MandateCard(
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
              child: MandateCard(
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
        IntegrationTile(
          theme: theme,
          textTheme: textTheme,
          title: 'Lightstone',
          isChecked: state.syncLightstone,
          onChanged: (val) =>
              viewModel.toggleSyncLightstone(val ?? false),
        ),
        const SizedBox(height: 12),
        IntegrationTile(
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
        OwnerCard(
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
            child: OwnerCard(
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
    );
  }
}
