import 'room.dart';

class RoomModel {
  final String id;
  final String name;
  final int roomTypeId;
  final String? roomTypeOther;
  final int? conditionRating;
  final List<String> features;
  final List<int> featureIds;
  final String notes;
  final String? photoUrl;
  final String createdAt;
  final String updatedAt;

  RoomModel({
    required this.id,
    required this.name,
    required this.roomTypeId,
    this.roomTypeOther,
    this.conditionRating,
    this.features = const [],
    this.featureIds = const [],
    this.notes = '',
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomModel.fromEntity(Room entity) {
    return RoomModel(
      id: entity.id,
      name: entity.name,
      roomTypeId: entity.roomTypeId,
      roomTypeOther: entity.roomTypeOther,
      conditionRating: entity.conditionRating,
      features: entity.features,
      featureIds: entity.featureIds,
      notes: entity.notes,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  Room toEntity() {
    return Room(
      id: id,
      name: name,
      roomTypeId: roomTypeId,
      roomTypeOther: roomTypeOther,
      conditionRating: conditionRating,
      features: features,
      featureIds: featureIds,
      notes: notes,
      photoUrl: photoUrl,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roomTypeId': roomTypeId,
      'roomTypeOther': roomTypeOther,
      'conditionRating': conditionRating,
      'features': features,
      'featureIds': featureIds,
      'notes': notes,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      roomTypeId: map['roomTypeId'] ?? 1,
      roomTypeOther: map['roomTypeOther'],
      conditionRating: map['conditionRating'],
      features: List<String>.from(map['features'] ?? []),
      featureIds: List<int>.from(map['featureIds'] ?? []),
      notes: map['notes'] ?? '',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
      updatedAt: map['updatedAt'] ?? DateTime.now().toIso8601String(),
    );
  }
}
