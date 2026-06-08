import '../data/models/enums/outdoor_extra.dart';
import '../data/models/enums/room_category.dart';
import '../data/models/outdoor_extra_item.dart';
import '../data/models/property_state.dart';
import '../data/models/room.dart';

extension PropertyFeaturesActions on PropertyState {
  PropertyState withAddedRoom(String name, RoomCategory category) {
    final newRoom = Room(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: category,
      description: 'Custom Space',
      isComplete: false,
    );
    return copyWith(rooms: [...rooms, newRoom]);
  }

  PropertyState withRemovedRoom(String roomId) {
    return copyWith(rooms: rooms.where((r) => r.id != roomId).toList());
  }

  PropertyState withAddedOutdoorExtra(String name,
      {OutdoorExtraCategory? category}) {
    final current = List<OutdoorExtraItem>.from(outdoorExtras);
    final existingIdx = current.indexWhere((item) => item.name == name);
    if (existingIdx >= 0) {
      current[existingIdx] = current[existingIdx].copyWith(
        quantity: current[existingIdx].quantity + 1,
      );
    } else {
      current.add(OutdoorExtraItem(name: name, category: category));
    }
    return copyWith(outdoorExtras: current);
  }

  PropertyState withRemovedOutdoorExtra(String name) {
    final current = List<OutdoorExtraItem>.from(outdoorExtras);
    current.removeWhere((item) => item.name == name);
    return copyWith(outdoorExtras: current);
  }

  PropertyState withIncrementedOutdoorQty(String name) {
    final current = List<OutdoorExtraItem>.from(outdoorExtras);
    final idx = current.indexWhere((item) => item.name == name);
    if (idx >= 0) {
      current[idx] =
          current[idx].copyWith(quantity: current[idx].quantity + 1);
      return copyWith(outdoorExtras: current);
    }
    return this;
  }

  PropertyState withDecrementedOutdoorQty(String name) {
    final current = List<OutdoorExtraItem>.from(outdoorExtras);
    final idx = current.indexWhere((item) => item.name == name);
    if (idx >= 0) {
      if (current[idx].quantity <= 1) {
        current.removeAt(idx);
      } else {
        current[idx] =
            current[idx].copyWith(quantity: current[idx].quantity - 1);
      }
      return copyWith(outdoorExtras: current);
    }
    return this;
  }
}
