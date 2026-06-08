enum EntityType {
  person,
  business,
}

extension EntityTypeExtension on EntityType {
  String get displayString {
    switch (this) {
      case EntityType.person:
        return 'Person';
      case EntityType.business:
        return 'Business';
    }
  }

  static EntityType fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'business':
        return EntityType.business;
      case 'person':
      default:
        return EntityType.person;
    }
  }
}
