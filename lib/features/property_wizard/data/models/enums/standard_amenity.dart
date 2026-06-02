enum StandardAmenity {
  ceilingFan,
  wallToWallCarpets,
  airConditioning,
  builtInCupboards,
  ensuiteBathroom,
  balcony,
}

extension StandardAmenityExtension on StandardAmenity {
  String get displayString {
    switch (this) {
      case StandardAmenity.ceilingFan:
        return 'Ceiling Fan';
      case StandardAmenity.wallToWallCarpets:
        return 'Wall-to-Wall Carpets';
      case StandardAmenity.airConditioning:
        return 'Air Conditioning';
      case StandardAmenity.builtInCupboards:
        return 'Built-in Cupboards';
      case StandardAmenity.ensuiteBathroom:
        return 'En-suite Bathroom';
      case StandardAmenity.balcony:
        return 'Balcony';
    }
  }
}
