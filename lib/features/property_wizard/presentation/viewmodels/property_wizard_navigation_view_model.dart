import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/navigation_state.dart';

final propertyWizardNavigationViewModelProvider = NotifierProvider<PropertyWizardNavigationViewModel, NavigationState>(() {
  return PropertyWizardNavigationViewModel();
});

class PropertyWizardNavigationViewModel extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    return NavigationState();
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 6) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void selectRoomForEditing(String? roomId) {
    if (roomId == null) {
      state = state.copyWith(clearRoomId: true);
    } else {
      state = state.copyWith(selectedRoomId: roomId);
    }
  }
}
