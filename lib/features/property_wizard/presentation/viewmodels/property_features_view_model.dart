import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realestate_app/features/property_wizard/presentation/viewmodels/states/property_features_state.dart';

import '../../domain/enums/room_category.dart';
import 'property_view_model.dart';

final propertyFeaturesViewModelProvider =
    NotifierProvider<PropertyFeaturesViewModel, PropertyFeaturesState>(() {
      return PropertyFeaturesViewModel();
    });

class PropertyFeaturesViewModel extends Notifier<PropertyFeaturesState> {
  @override
  PropertyFeaturesState build() {
    // Initialize from the main PropertyViewModel state
    final mainState = ref.read(propertyViewModelProvider);
    return PropertyFeaturesState(
      rooms: mainState.rooms,
      outdoorExtras: mainState.outdoorExtras,
    );
  }

  // Helper to access the main ViewModel
  PropertyViewModel get _main => ref.read(propertyViewModelProvider.notifier);

  // Room actions
  void addCustomRoom(String name, RoomCategory category) {
    _main.addCustomRoom(name, category);
    // Refresh local state
    state = state.copyWith(rooms: ref.read(propertyViewModelProvider).rooms);
  }

  void toggleOutdoorExtra(String extra) {
    _main.toggleOutdoorExtra(extra);
    state = state.copyWith(
      outdoorExtras: ref.read(propertyViewModelProvider).outdoorExtras,
    );
  }

  void addCustomOutdoorExtra(String extra) {
    _main.addCustomOutdoorExtra(extra);
    state = state.copyWith(
      outdoorExtras: ref.read(propertyViewModelProvider).outdoorExtras,
    );
  }

  void selectRoomForEditing(String roomId) {
    _main.selectRoomForEditing(roomId);
    // No specific state change needed here
  }

  // Additional methods can be proxied as needed
}
