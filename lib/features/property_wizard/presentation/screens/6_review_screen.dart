import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../data/models/enums/architectural_style.dart';
import '../../data/models/enums/facing_direction.dart';
import '../../data/models/enums/lead_source.dart';
import '../../data/models/enums/mandate_type.dart';
import '../../data/models/enums/property_subtype.dart';
import '../../data/models/enums/property_type.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../data/models/enums/roof_configuration.dart';
import '../../data/models/enums/room_category.dart';
import '../../data/models/enums/wall_exterior.dart';
import '../../application/providers/property_provider.dart';
import '../../application/providers/wizard_navigation_provider.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

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
                'Review & Submit',
                style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 6),
              Text(
                'Review all property details before submitting.',
                style: textTheme.bodyMedium?.copyWith(color: theme.textSecondary.withOpacity(0.9)),
              ),
              const SizedBox(height: 28),
              _buildSectionCard(
                theme: theme, textTheme: textTheme,
                title: 'PROPERTY TYPE',
                children: [
                  _buildDetailRow(textTheme, 'Type', state.propertyType.displayString),
                  _buildDetailRow(textTheme, 'Subtype', state.propertySubtype.displayString),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                theme: theme, textTheme: textTheme,
                title: 'ADDRESS',
                children: [
                  _buildDetailRow(textTheme, 'Street', state.streetAddress),
                  _buildDetailRow(textTheme, 'Suburb', state.suburb),
                  _buildDetailRow(textTheme, 'City', state.city),
                  _buildDetailRow(textTheme, 'Province', state.province),
                  _buildDetailRow(textTheme, 'Postal Code', state.postalCode),
                  if (state.complexName.isNotEmpty) _buildDetailRow(textTheme, 'Complex', state.complexName),
                  if (state.erfPlotNumber.isNotEmpty) _buildDetailRow(textTheme, 'Erf / Plot', state.erfPlotNumber),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                theme: theme, textTheme: textTheme,
                title: 'BUILDING INFO',
                children: [
                  if (state.erfSize.isNotEmpty) _buildDetailRow(textTheme, 'Erf Size', '${state.erfSize} m²'),
                  if (state.floorArea.isNotEmpty) _buildDetailRow(textTheme, 'Floor Area', '${state.floorArea} m²'),
                  if (state.constructionYear.isNotEmpty) _buildDetailRow(textTheme, 'Construction Year', state.constructionYear),
                  if (state.maxHeight.isNotEmpty) _buildDetailRow(textTheme, 'Max Height', '${state.maxHeight} m'),
                  if (state.zoning.isNotEmpty) _buildDetailRow(textTheme, 'Zoning', state.zoning),
                  _buildDetailRow(textTheme, 'Facing', state.facingDirection.displayString),
                  _buildDetailRow(textTheme, 'Architecture', state.architecturalStyle.displayString),
                  _buildDetailRow(textTheme, 'Roof', state.roofConfiguration.displayString),
                  _buildDetailRow(textTheme, 'Walls', state.wallExterior.displayString),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                theme: theme, textTheme: textTheme,
                title: 'PROPERTY FEATURES',
                children: [
                  _buildDetailRow(textTheme, 'Rooms', state.rooms.isEmpty ? 'None' : '${state.rooms.length} room(s)'),
                  ...state.rooms.map((room) => Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text(
                      '• ${room.name} (${room.type.displayString})${room.isComplete ? '' : ' — PENDING'}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: room.isComplete ? theme.textPrimary : theme.pendingColor,
                      ),
                    ),
                  )),
                  const SizedBox(height: 8),
                  _buildDetailRow(textTheme, 'Outdoor Extras', state.outdoorExtras.isEmpty ? 'None' : state.outdoorExtras.map((e) => e.quantity > 1 ? '${e.name} x${e.quantity}' : e.name).join(', ')),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                theme: theme, textTheme: textTheme,
                title: 'MANDATE & CONTACTS',
                children: [
                  _buildDetailRow(textTheme, 'Mandate Type', state.mandateType.displayString),
                  _buildDetailRow(textTheme, 'Lead Source', state.leadSource.displayString),
                  _buildDetailRow(textTheme, 'Sync Lightstone', state.syncLightstone ? 'Yes' : 'No'),
                  _buildDetailRow(textTheme, 'Sync Loom', state.syncLoom ? 'Yes' : 'No'),
                  const SizedBox(height: 8),
                  Text('Owner', style: textTheme.labelLarge?.copyWith(color: theme.textLabel, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildDetailRow(textTheme, 'Name', '${state.ownerFirstName} ${state.ownerLastName}'),
                  _buildDetailRow(textTheme, 'Email', state.ownerEmail),
                  _buildDetailRow(textTheme, 'Phone', state.ownerPhone),
                  _buildDetailRow(textTheme, 'ID Number', state.ownerIdNumber.isEmpty ? '—' : state.ownerIdNumber),
                  if (state.mandateStart != null || state.mandateEnd != null) ...[
                    const SizedBox(height: 8),
                    if (state.mandateStart != null) _buildDetailRow(textTheme, 'Mandate Start', state.mandateStart!),
                    if (state.mandateEnd != null) _buildDetailRow(textTheme, 'Mandate End', state.mandateEnd!),
                  ],
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: theme.borderLight, width: 1.0)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: CustomButton(
              text: 'Submit Listing',
              onTap: () {
                viewModel.saveDraft();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Property listing submitted successfully!'),
                    backgroundColor: theme.primaryColor,
                  ),
                );
                context.go(PropertyWizardStep.propertyType.routePath);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required RealEstateTheme theme,
    required TextTheme textTheme,
    required String title,
    required List<Widget> children,
  }) {
    return CustomCard(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: theme.textLabel,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(TextTheme textTheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
