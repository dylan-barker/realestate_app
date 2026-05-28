import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../application/providers/wizard_navigation_provider.dart';

class WizardFooter extends ConsumerWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const WizardFooter({
    super.key,
    this.onNext,
    this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navData = ref.watch(wizardNavigationProvider);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: theme.borderLight, width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side
          if (navData.currentStep.stepNumber == 4)
            CustomButton(
              text: 'Back',
              type: ButtonType.back,
              onTap: onBack ?? () {},
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  navData.progressLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: theme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  navData.currentStep.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),

          // Right side
          CustomButton(
            text: 'Next',
            icon: navData.currentStep.stepNumber == 2
                ? const Icon(Icons.arrow_forward, color: Colors.white, size: 16)
                : navData.currentStep.stepNumber == 4
                    ? const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14)
                    : null,
            onTap: navData.canGoNext ? (onNext ?? () {}) : null,
          ),
        ],
      ),
    );
  }
}
