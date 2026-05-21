import 'room_model.dart';

class PropertyStateModel {
  final int currentStep;
  
  // Step 1: Property Type
  final String propertyType;
  final String propertySubtype;

  // Step 2: Address & Identification
  final String streetAddress;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;
  final String complexName;
  final String erfPlotNumber;

  // Step 3: Building Info (Technical Specs)
  final String erfSize;
  final String floorArea;
  final String constructionYear;
  final String maxHeight;
  final String zoning;
  
  // Step 3 Selectors
  final String facingDirection;
  final String architecturalStyle;
  final String roofConfiguration;
  final String wallExterior;

  // Step 4: Property Features
  final List<RoomModel> rooms;
  final List<String> outdoorExtras;

  // Step 4.2: Selected Room details being active
  final String? selectedRoomId;

  PropertyStateModel({
    this.currentStep = 1,
    this.propertyType = 'House',
    this.propertySubtype = 'Free Standing',
    this.streetAddress = '124 Architecture Way',
    this.suburb = 'Westside Hills',
    this.city = 'San Francisco',
    this.province = 'California',
    this.postalCode = '94103',
    this.complexName = '',
    this.erfPlotNumber = '',
    this.erfSize = '0.00',
    this.floorArea = '0.00',
    this.constructionYear = 'YYYY',
    this.maxHeight = '0.00',
    this.zoning = 'e.g. Residential 1',
    this.facingDirection = 'North',
    this.architecturalStyle = 'Contemporary',
    this.roofConfiguration = 'Hipped',
    this.wallExterior = 'Brick',
    this.rooms = const [],
    this.outdoorExtras = const ['Swimming Pool'],
    this.selectedRoomId,
  });

  PropertyStateModel copyWith({
    int? currentStep,
    String? propertyType,
    String? propertySubtype,
    String? streetAddress,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
    String? complexName,
    String? erfPlotNumber,
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
    String? facingDirection,
    String? architecturalStyle,
    String? roofConfiguration,
    String? wallExterior,
    List<RoomModel>? rooms,
    List<String>? outdoorExtras,
    String? selectedRoomId,
  }) {
    return PropertyStateModel(
      currentStep: currentStep ?? this.currentStep,
      propertyType: propertyType ?? this.propertyType,
      propertySubtype: propertySubtype ?? this.propertySubtype,
      streetAddress: streetAddress ?? this.streetAddress,
      suburb: suburb ?? this.suburb,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      complexName: complexName ?? this.complexName,
      erfPlotNumber: erfPlotNumber ?? this.erfPlotNumber,
      erfSize: erfSize ?? this.erfSize,
      floorArea: floorArea ?? this.floorArea,
      constructionYear: constructionYear ?? this.constructionYear,
      maxHeight: maxHeight ?? this.maxHeight,
      zoning: zoning ?? this.zoning,
      facingDirection: facingDirection ?? this.facingDirection,
      architecturalStyle: architecturalStyle ?? this.architecturalStyle,
      roofConfiguration: roofConfiguration ?? this.roofConfiguration,
      wallExterior: wallExterior ?? this.wallExterior,
      rooms: rooms ?? this.rooms,
      outdoorExtras: outdoorExtras ?? this.outdoorExtras,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
    );
  }
}
