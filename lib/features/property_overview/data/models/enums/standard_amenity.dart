enum AmenityCategory { kitchen, bedroomBathroom, livingAreas, generalInterior }

extension AmenityCategoryExtension on AmenityCategory {
  String get displayString {
    switch (this) {
      case AmenityCategory.kitchen:
        return 'Kitchen';
      case AmenityCategory.bedroomBathroom:
        return 'Bedroom / Bathroom';
      case AmenityCategory.livingAreas:
        return 'Living Areas';
      case AmenityCategory.generalInterior:
        return 'General Interior';
    }
  }
}

enum StandardAmenity {
  builtInCupboards('Built-in Cupboards', AmenityCategory.kitchen),
  graniteCountertops('Granite / Stone Countertops', AmenityCategory.kitchen),
  gasHob('Gas Hob', AmenityCategory.kitchen),
  eyeLevelOven('Eye-level Oven', AmenityCategory.kitchen),
  undercounterOvenHob('Undercounter Oven & Hob', AmenityCategory.kitchen),
  extractorFan('Extractor Fan', AmenityCategory.kitchen),
  kitchenIsland('Kitchen Island / Prep Bowl', AmenityCategory.kitchen),
  dishwasherConnection('Dishwasher Connection', AmenityCategory.kitchen),
  washingMachineConnection(
    'Washing Machine Connection',
    AmenityCategory.kitchen,
  ),
  breakfastNook('Breakfast Nook', AmenityCategory.kitchen),
  walkInCloset('Walk-in Closet', AmenityCategory.bedroomBathroom),
  ensuiteBathroom('En-suite Bathroom', AmenityCategory.bedroomBathroom),
  ceilingFan('Ceiling Fan', AmenityCategory.bedroomBathroom),
  balconyAccess('Balcony Access', AmenityCategory.bedroomBathroom),
  fireplace('Fireplace', AmenityCategory.livingAreas),
  underfloorHeating('Underfloor Heating', AmenityCategory.livingAreas),
  builtInBraai('Built-in Braai', AmenityCategory.livingAreas),
  builtInBar('Built-in Bar', AmenityCategory.livingAreas),
  airConditioning('Air Conditioning', AmenityCategory.livingAreas),
  tiledFloors('Tiled Floors', AmenityCategory.livingAreas),
  woodenLaminateFloors('Wooden / Laminate Floors', AmenityCategory.livingAreas),
  highCeilings(
    'High Ceilings / Exposed Beams / Exposed Trusses',
    AmenityCategory.livingAreas,
  ),
  fibreReady('Fibre Ready / Fibre Installed', AmenityCategory.generalInterior),
  alarmSystem('Alarm System', AmenityCategory.generalInterior),
  intercom('Intercom', AmenityCategory.generalInterior),
  cctv('CCTV / Security Cameras', AmenityCategory.generalInterior),
  safetyGates('Safety Gates', AmenityCategory.generalInterior);

  final String displayString;
  final AmenityCategory category;

  const StandardAmenity(this.displayString, this.category);

  static StandardAmenity? fromString(String val) {
    for (final amenity in StandardAmenity.values) {
      if (amenity.displayString.toLowerCase() == val.trim().toLowerCase()) {
        return amenity;
      }
    }
    return null;
  }
}
