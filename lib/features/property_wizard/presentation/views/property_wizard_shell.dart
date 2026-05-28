import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/property_state.dart';
import '../viewmodels/property_view_model.dart';
import 'address_step.dart';
import 'building_info_step.dart';
import 'mandate_contacts_step.dart';
import 'property_features_step.dart';
import 'property_type_step.dart';
import 'room_details_step.dart';

class PropertyWizardShell extends ConsumerWidget {
  const PropertyWizardShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;

    // Check if a specific room is being configured (Step 4.2)
    final isEditingRoom = state.selectedRoomId != null;

    // Resolve header title based on current step
    String headerTitle = 'Property Details';
    if (state.currentStep == 3) {
      headerTitle = 'Building Info';
    } else if (state.currentStep == 5) {
      headerTitle = 'Mandate & Contacts';
    }

    Widget stepView;
    if (isEditingRoom) {
      stepView = const RoomDetailsStep();
    } else {
      switch (state.currentStep) {
        case 1:
          stepView = const PropertyTypeStep();
          break;
        case 2:
          stepView = const AddressStep();
          break;
        case 3:
          stepView = const BuildingInfoStep();
          break;
        case 4:
          stepView = const PropertyFeaturesStep();
          break;
        case 5:
          stepView = const MandateContactsStep();
          break;
        default:
          stepView = const PropertyTypeStep();
      }
    }

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.textPrimary,
            size: 20,
          ),
          onPressed: () {
            if (isEditingRoom) {
              viewModel.selectRoomForEditing(null);
            } else if (state.currentStep > 1) {
              viewModel.prevStep();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          isEditingRoom ? 'Property Details' : headerTitle,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          // Sleek brand letters logo placeholder
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'K',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: theme.textPrimary,
                  ),
                ),
                Text(
                  'W',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: theme.borderLight, height: 1.0),
        ),
      ),
      body: SafeArea(child: stepView),
      // Standardized dynamic footers
      bottomNavigationBar: isEditingRoom
          ? null // No footer in Step 4.2 Room Details as per screenshot
          : _buildFooter(context, ref, state, viewModel, theme, textTheme),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    WidgetRef ref,
    PropertyState state,
    PropertyViewModel viewModel,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: theme.borderLight, width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side descriptions or back button
          if (state.currentStep == 1)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 1 of 6',
                  style: textTheme.labelMedium?.copyWith(
                    color: theme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Property Type',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            )
          else if (state.currentStep == 2)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROGRESS',
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Step 2 of 6',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            )
          else if (state.currentStep == 5)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROGRESS',
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Step 5 of 6',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            )
          else if (state.currentStep == 3)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT PROGRESS',
                      style: textTheme.labelLarge?.copyWith(
                        color: theme.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Step 3 of 6',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    viewModel.saveDraft();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Draft saved successfully'),
                        backgroundColor: theme.primaryColor,
                      ),
                    );
                  },
                  child: Text(
                    'Save Draft',
                    style: textTheme.bodyLarge?.copyWith(
                      color: theme.textLabel,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          else if (state.currentStep == 4)
            CustomButton(
              text: 'Back',
              type: ButtonType.back,
              onTap: () => viewModel.prevStep(),
            ),

          // Right side CTA button
          if (state.currentStep == 2)
            CustomButton(
              text: 'Next',
              icon: Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              onTap: () => viewModel.nextStep(),
            )
          else if (state.currentStep == 4)
            CustomButton(
              text: 'Next',
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 14,
              ),
              onTap: () {
                viewModel.nextStep();
              },
            )
          else
            CustomButton(text: 'Next', onTap: () => viewModel.nextStep()),
        ],
      ),
    );
  }
}
