import '../enums/room_category.dart';

class Room {
  final String id;
  final String name;
  final RoomCategory type;
  final String description;
  final bool isComplete;
  final int? conditionRating;
  final List<String> features;
  final String notes;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.isComplete = false,
    this.conditionRating,
    this.features = const [],
    this.notes = '',
  });

  Room copyWith({
    String? id,
    String? name,
    RoomCategory? type,
    String? description,
    bool? isComplete,
    int? conditionRating,
    List<String>? features,
    String? notes,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      isComplete: isComplete ?? this.isComplete,
      conditionRating: conditionRating ?? this.conditionRating,
      features: features ?? this.features,
      notes: notes ?? this.notes,
    );
  }
}
