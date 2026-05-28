import '../../../data/models/room.dart';

class PropertyFeaturesState {
  final List<Room> rooms;
  final List<String> outdoorExtras;

  const PropertyFeaturesState({
    this.rooms = const [],
    this.outdoorExtras = const [],
  });

  PropertyFeaturesState copyWith({
    List<Room>? rooms,
    List<String>? outdoorExtras,
  }) {
    return PropertyFeaturesState(
      rooms: rooms ?? this.rooms,
      outdoorExtras: outdoorExtras ?? this.outdoorExtras,
    );
  }

}
