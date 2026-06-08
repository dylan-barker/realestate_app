import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/enums/property_wizard_step.dart';
import '../../providers/property_provider.dart';

void advanceWizard(BuildContext context, WidgetRef ref) {
  final viewModel = ref.read(propertyViewModelProvider.notifier);
  viewModel.nextStep();
  final step = PropertyWizardStep.fromStepNumber(
    ref.read(propertyViewModelProvider).currentStep,
  );
  context.push(step.routePath);
}

void goBackWizard(BuildContext context, WidgetRef ref) {
  final viewModel = ref.read(propertyViewModelProvider.notifier);
  viewModel.prevStep();
  context.pop();
}
