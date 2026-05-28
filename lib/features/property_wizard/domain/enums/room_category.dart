enum RoomCategory {
  bedrooms,
  livingAndDining,
  bathroomsAndPowder,
}

extension RoomCategoryExtension on RoomCategory {
  String get displayString {
    switch (this) {
      case RoomCategory.bedrooms:
        return 'Bedrooms';
      case RoomCategory.livingAndDining:
        return 'Living & Dining';
      case RoomCategory.bathroomsAndPowder:
        return 'Bathrooms & Powder';
    }
  }

  static RoomCategory fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'living & dining':
      case 'livinganddining':
      case 'living & dining room':
        return RoomCategory.livingAndDining;
      case 'bathrooms & powder':
      case 'bathroomsandpowder':
      case 'bathrooms & powder room':
        return RoomCategory.bathroomsAndPowder;
      case 'bedrooms':
      default:
        return RoomCategory.bedrooms;
    }
  }
}
