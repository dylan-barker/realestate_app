class RoomFeature {
  final String description;
  final int? featureId;
  final int? customId;

  const RoomFeature({required this.description, this.featureId, this.customId});

  bool get isPredefined => featureId != null;

  bool get isPersisted => featureId != null || customId != null;

  RoomFeature copyWith({int? featureId, int? customId}) {
    return RoomFeature(
      description: description,
      featureId: featureId ?? this.featureId,
      customId: customId ?? this.customId,
    );
  }
}

class Room {
  final String id;
  final String name;
  final int roomTypeId;
  final String? roomTypeOther;
  final int? conditionRating;
  final List<RoomFeature> features;
  final List<String> hiddenFeatures;
  final String notes;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.name,
    this.roomTypeId = 1,
    this.roomTypeOther,
    this.conditionRating,
    this.features = const [],
    this.hiddenFeatures = const [],
    this.notes = '',
    this.photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Room copyWith({
    String? id,
    String? name,
    int? roomTypeId,
    String? roomTypeOther,
    int? conditionRating,
    List<RoomFeature>? features,
    List<String>? hiddenFeatures,
    String? notes,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      roomTypeId: roomTypeId ?? this.roomTypeId,
      roomTypeOther: roomTypeOther ?? this.roomTypeOther,
      conditionRating: conditionRating ?? this.conditionRating,
      features: features ?? this.features,
      hiddenFeatures: hiddenFeatures ?? this.hiddenFeatures,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
