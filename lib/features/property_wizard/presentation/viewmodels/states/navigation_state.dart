class NavigationState {
  final int currentStep;
  final String? selectedRoomId;

  NavigationState({
    this.currentStep = 1,
    this.selectedRoomId,
  });

  NavigationState copyWith({
    int? currentStep,
    String? selectedRoomId,
    bool clearRoomId = false,
  }) {
    return NavigationState(
      currentStep: currentStep ?? this.currentStep,
      selectedRoomId: clearRoomId ? null : (selectedRoomId ?? this.selectedRoomId),
    );
  }
}
