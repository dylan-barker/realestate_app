enum OutdoorExtra {
  swimmingPool,
  threeCarGarage,
  patioDeck,
  fireplace,
}

extension OutdoorExtraExtension on OutdoorExtra {
  String get displayString {
    switch (this) {
      case OutdoorExtra.swimmingPool:
        return 'Swimming Pool';
      case OutdoorExtra.threeCarGarage:
        return '3-Car Garage';
      case OutdoorExtra.patioDeck:
        return 'Patio / Deck';
      case OutdoorExtra.fireplace:
        return 'Fireplace';
    }
  }

  static OutdoorExtra fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'swimming pool':
        return OutdoorExtra.swimmingPool;
      case '3-car garage':
        return OutdoorExtra.threeCarGarage;
      case 'patio / deck':
      case 'patio/deck':
        return OutdoorExtra.patioDeck;
      case 'fireplace':
      default:
        return OutdoorExtra.fireplace;
    }
  }
}
