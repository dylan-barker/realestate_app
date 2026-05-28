import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/enums/room_category.dart';
import 'states/property_features_state.dart';
import 'property_provider.dart';

final propertyFeaturesViewModelProvider =
    NotifierProvider<PropertyFeaturesViewModel, PropertyFeaturesState>(() {
      return PropertyFeaturesViewModel();
    });

class PropertyFeaturesViewModel extends Notifier<PropertyFeaturesState> {
  @override
  PropertyFeaturesState build() {
    final mainState = ref.watch(propertyViewModelProvider);
    return PropertyFeaturesState(
      rooms: mainState.rooms,
      outdoorExtras: mainState.outdoorExtras,
    );
  }

  void addCustomRoom(String name, RoomCategory category) {
    ref.read(propertyViewModelProvider.notifier).addCustomRoom(name, category);
  }

  void toggleOutdoorExtra(String extra) {
    ref.read(propertyViewModelProvider.notifier).toggleOutdoorExtra(extra);
  }

  void addCustomOutdoorExtra(String extra) {
    ref.read(propertyViewModelProvider.notifier).addCustomOutdoorExtra(extra);
  }

  void selectRoomForEditing(String roomId) {
    ref.read(propertyViewModelProvider.notifier).selectRoomForEditing(roomId);
  }
}
