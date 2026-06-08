import 'enums/architectural_style.dart';
import 'enums/facing_direction.dart';
import 'enums/lead_source.dart';
import 'enums/mandate_type.dart';
import 'enums/property_subtype.dart';
import 'enums/property_type.dart';
import 'enums/roof_configuration.dart';
import 'enums/wall_exterior.dart';
import 'outdoor_extra_item.dart';
import 'owner.dart';
import 'room.dart';

class PropertyState {
  final int currentStep;

  // Step 1: Property Type & Subtype
  final PropertyType propertyType;
  final PropertySubtype propertySubtype;

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

  // Step 3 Selectors (Enums)
  final FacingDirection facingDirection;
  final ArchitecturalStyle architecturalStyle;
  final RoofConfiguration roofConfiguration;
  final WallExterior wallExterior;

  // Step 4: Property Features
  final List<Room> rooms;
  final List<OutdoorExtraItem> outdoorExtras;

  // Step 4.2: Selected Room details being active
  final String? selectedRoomId;

  // Step 5: Mandate & Contacts
  final MandateType mandateType;
  final LeadSource leadSource;
  final bool syncLightstone;
  final bool syncLoom;
  final Owner primaryOwner;
  final List<Owner> coOwners;
  final String? mandateStart;
  final String? mandateEnd;

  PropertyState({
    this.currentStep = 1,
    this.propertyType = PropertyType.house,
    this.propertySubtype = PropertySubtype.freeStanding,
    this.streetAddress = '124 Some Street',
    this.suburb = 'Strand',
    this.city = 'Cape Town',
    this.province = 'Western Cape',
    this.postalCode = '7140',
    this.complexName = '',
    this.erfPlotNumber = '',
    this.erfSize = '',
    this.floorArea = '',
    this.constructionYear = '',
    this.maxHeight = '',
    this.zoning = '',
    this.facingDirection = FacingDirection.north,
    this.architecturalStyle = ArchitecturalStyle.contemporary,
    this.roofConfiguration = RoofConfiguration.hipped,
    this.wallExterior = WallExterior.brick,
    this.rooms = const [],
    this.outdoorExtras = const [],
    this.selectedRoomId,
    this.mandateType = MandateType.exclusive,
    this.leadSource = LeadSource.referral,
    this.syncLightstone = true,
    this.syncLoom = false,
    this.primaryOwner = const Owner(),
    this.coOwners = const [],
    this.mandateStart,
    this.mandateEnd,
  });

  PropertyState copyWith({
    int? currentStep,
    PropertyType? propertyType,
    PropertySubtype? propertySubtype,
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
    FacingDirection? facingDirection,
    ArchitecturalStyle? architecturalStyle,
    RoofConfiguration? roofConfiguration,
    WallExterior? wallExterior,
    List<Room>? rooms,
    List<OutdoorExtraItem>? outdoorExtras,
    String? selectedRoomId,
    MandateType? mandateType,
    LeadSource? leadSource,
    bool? syncLightstone,
    bool? syncLoom,
    Owner? primaryOwner,
    List<Owner>? coOwners,
    String? mandateStart,
    String? mandateEnd,
  }) {
    return PropertyState(
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
      mandateType: mandateType ?? this.mandateType,
      leadSource: leadSource ?? this.leadSource,
      syncLightstone: syncLightstone ?? this.syncLightstone,
      syncLoom: syncLoom ?? this.syncLoom,
      primaryOwner: primaryOwner ?? this.primaryOwner,
      coOwners: coOwners ?? this.coOwners,
      mandateStart: mandateStart ?? this.mandateStart,
      mandateEnd: mandateEnd ?? this.mandateEnd,
    );
  }
}
