import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/screens/home_screen.dart'
    show listingsProvider;
import '../../data/models/enums/property_type.dart';
import '../../providers/property_provider.dart';
import '../widgets/section_card.dart';

class PropertyOverviewScreen extends ConsumerWidget {
  final int propertyId;

  const PropertyOverviewScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeConfigProvider);
    final textTheme = theme.toThemeData().textTheme;

    if (state.listingId != propertyId) {
      viewModel.loadListing(propertyId);
    }

    final sections = [
      _SectionData(
        title: 'Property Type',
        subtitle: _propertyTypeLabel(state.propertyTypeId),
        icon: Icons.home_outlined,
        route: AppRoutes.propertyType(propertyId),
        isComplete: state.propertyTypeId > 0,
      ),
      _SectionData(
        title: 'Address',
        subtitle: state.street.isNotEmpty
            ? '${state.streetNumber} ${state.street}'
            : 'Not provided',
        icon: Icons.location_on_outlined,
        route: AppRoutes.address(propertyId),
        isComplete: state.street.isNotEmpty && state.city.isNotEmpty,
      ),
      _SectionData(
        title: 'Building Info',
        subtitle: state.erfSize.isNotEmpty
            ? '${state.erfSize} m\u00B2'
            : 'Not provided',
        icon: Icons.architecture_outlined,
        route: AppRoutes.buildingInfo(propertyId),
        isComplete: state.erfSize.isNotEmpty || state.floorArea.isNotEmpty,
      ),
      _SectionData(
        title: 'Property Features',
        subtitle: state.rooms.isNotEmpty
            ? '${state.rooms.length} room(s)'
            : 'Not provided',
        icon: Icons.meeting_room_outlined,
        route: AppRoutes.propertyFeatures(propertyId),
        isComplete: state.rooms.isNotEmpty,
      ),
      _SectionData(
        title: 'Valuation & Costs',
        subtitle: state.listingValuation.ownersNetPrice.isNotEmpty
            ? 'R ${state.listingValuation.ownersNetPrice}'
            : 'Not provided',
        icon: Icons.account_balance_wallet_outlined,
        route: AppRoutes.valuationCosts(propertyId),
        isComplete: state.listingValuation.ownersNetPrice.isNotEmpty,
      ),
      _SectionData(
        title: 'Contacts',
        subtitle: state.primaryContact.fullName.isNotEmpty
            ? state.primaryContact.fullName
            : 'Not provided',
        icon: Icons.contacts_outlined,
        route: AppRoutes.contacts(propertyId),
        isComplete: state.primaryContact.fullName.isNotEmpty,
      ),
    ];

    final allComplete = sections.every((s) => s.isComplete);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardBackgroundColor,
        surfaceTintColor: theme.cardBackgroundColor,
        title: Text(
          'Property Details',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.textPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            onPressed: () =>
                _confirmDelete(context, ref, viewModel, propertyId),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.borderLight, height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reference: ${state.referenceNumber}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...sections.map(
                      (section) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SectionCard(
                          title: section.title,
                          subtitle: section.subtitle,
                          icon: section.icon,
                          isComplete: section.isComplete,
                          theme: theme,
                          textTheme: textTheme,
                          onTap: () => context.push(section.route),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (allComplete)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.cardBackgroundColor,
                  border: Border(
                    top: BorderSide(color: theme.borderLight, width: 1),
                  ),
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: CustomButton(
                      text: 'Submit Evaluation',
                      onTap: () async {
                        final success = await viewModel.submitAndSave();
                        if (!context.mounted) return;
                        if (success) {
                          viewModel.reset();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Evaluation submitted successfully!',
                              ),
                              backgroundColor: theme.primaryColor,
                            ),
                          );
                          context.go(AppRoutes.homePath);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.errorMessage ??
                                    'Failed to submit evaluation',
                              ),
                              backgroundColor: Colors.red.shade700,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _propertyTypeLabel(int id) {
    if (id < 1 || id > PropertyType.values.length) return 'Not selected';
    return PropertyType.values[id - 1].displayString;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PropertyViewModel viewModel,
    int propertyId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'Are you sure you want to delete this property? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await viewModel.deleteListing();
      if (context.mounted) {
        ref.invalidate(listingsProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Property deleted')));
        context.go(AppRoutes.homePath);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapFailure(e).message)),
        );
      }
    }
  }
}

class _SectionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool isComplete;

  const _SectionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.isComplete,
  });
}
