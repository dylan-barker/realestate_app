class PropertyTypeDto {
  final int id;
  final String name;
  final int sortOrder;
  final bool isActive;

  const PropertyTypeDto({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });
}

class RoomTypeDto {
  final int id;
  final String description;

  const RoomTypeDto({required this.id, required this.description});
}

class FeatureDto {
  final int id;
  final String category;
  final String description;

  const FeatureDto({
    required this.id,
    required this.category,
    required this.description,
  });
}

class ConditionCategoryDto {
  final int id;
  final String description;

  const ConditionCategoryDto({required this.id, required this.description});
}

class ParkingTypeDto {
  final int id;
  final String description;

  const ParkingTypeDto({required this.id, required this.description});
}

class FacingDto {
  final int id;
  final String description;

  const FacingDto({required this.id, required this.description});
}

class ZoningDto {
  final int id;
  final String description;

  const ZoningDto({required this.id, required this.description});
}
