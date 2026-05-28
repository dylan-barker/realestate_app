import '../../domain/entities/room.dart';
import '../../domain/enums/room_category.dart';

class RoomModel {
  final String id;
  final String name;
  final String type; // String representation for serialized data
  final String description;
  final bool isComplete;
  final int? conditionRating;
  final List<String> features;
  final String notes;

  RoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.isComplete = false,
    this.conditionRating,
    this.features = const [],
    this.notes = '',
  });

  /// Convert Room Entity to RoomModel
  factory RoomModel.fromEntity(Room entity) {
    return RoomModel(
      id: entity.id,
      name: entity.name,
      type: entity.type.displayString,
      description: entity.description,
      isComplete: entity.isComplete,
      conditionRating: entity.conditionRating,
      features: entity.features,
      notes: entity.notes,
    );
  }

  /// Convert RoomModel to pure Room Domain Entity
  Room toEntity() {
    return Room(
      id: id,
      name: name,
      type: RoomCategoryExtension.fromString(type),
      description: description,
      isComplete: isComplete,
      conditionRating: conditionRating,
      features: features,
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'isComplete': isComplete,
      'conditionRating': conditionRating,
      'features': features,
      'notes': notes,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Bedrooms',
      description: map['description'] ?? '',
      isComplete: map['isComplete'] ?? false,
      conditionRating: map['conditionRating'],
      features: List<String>.from(map['features'] ?? []),
      notes: map['notes'] ?? '',
    );
  }
}
