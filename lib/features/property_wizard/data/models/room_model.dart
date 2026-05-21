class RoomModel {
  final String id;
  final String name;
  final String type; // e.g. 'Bedroom', 'Living & Dining', 'Bathrooms & Powder'
  final String description; // e.g. 'Master Suite', 'Standard', 'Guest Room'
  final bool isComplete;
  final int? conditionRating; // Level 1 to 4 rating
  final List<String> features; // Amenities like Ceiling Fan, Aircon
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

  RoomModel copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    bool? isComplete,
    int? conditionRating,
    List<String>? features,
    String? notes,
  }) {
    return RoomModel(
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
