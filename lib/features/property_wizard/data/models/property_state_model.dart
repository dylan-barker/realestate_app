import '../../domain/entities/property_state.dart';
import '../../domain/enums/architectural_style.dart';
import '../../domain/enums/facing_direction.dart';
import '../../domain/enums/lead_source.dart';
import '../../domain/enums/mandate_type.dart';
import '../../domain/enums/property_subtype.dart';
import '../../domain/enums/property_type.dart';
import '../../domain/enums/roof_configuration.dart';
import '../../domain/enums/wall_exterior.dart';
import 'room_model.dart';

class PropertyStateModel {
  final int currentStep;
  final String propertyType;
  final String propertySubtype;
  final String streetAddress;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;
  final String complexName;
  final String erfPlotNumber;
  final String erfSize;
  final String floorArea;
  final String constructionYear;
  final String maxHeight;
  final String zoning;
  final String facingDirection;
  final String architecturalStyle;
  final String roofConfiguration;
  final String wallExterior;
  final List<RoomModel> rooms;
  final List<String> outdoorExtras;
  final String? selectedRoomId;
  final String mandateType;
  final String leadSource;
  final bool syncLightstone;
  final bool syncLoom;
  final String ownerFirstName;
  final String ownerLastName;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerIdNumber;
  final String? mandateStart;
  final String? mandateEnd;

  PropertyStateModel({
    required this.currentStep,
    required this.propertyType,
    required this.propertySubtype,
    required this.streetAddress,
    required this.suburb,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.complexName,
    required this.erfPlotNumber,
    required this.erfSize,
    required this.floorArea,
    required this.constructionYear,
    required this.maxHeight,
    required this.zoning,
    required this.facingDirection,
    required this.architecturalStyle,
    required this.roofConfiguration,
    required this.wallExterior,
    required this.rooms,
    required this.outdoorExtras,
    this.selectedRoomId,
    required this.mandateType,
    required this.leadSource,
    required this.syncLightstone,
    required this.syncLoom,
    required this.ownerFirstName,
    required this.ownerLastName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.ownerIdNumber,
    this.mandateStart,
    this.mandateEnd,
  });

  /// Convert PropertyState Domain Entity to PropertyStateModel
  factory PropertyStateModel.fromEntity(PropertyState entity) {
    return PropertyStateModel(
      currentStep: entity.currentStep,
      propertyType: entity.propertyType.displayString,
      propertySubtype: entity.propertySubtype.displayString,
      streetAddress: entity.streetAddress,
      suburb: entity.suburb,
      city: entity.city,
      province: entity.province,
      postalCode: entity.postalCode,
      complexName: entity.complexName,
      erfPlotNumber: entity.erfPlotNumber,
      erfSize: entity.erfSize,
      floorArea: entity.floorArea,
      constructionYear: entity.constructionYear,
      maxHeight: entity.maxHeight,
      zoning: entity.zoning,
      facingDirection: entity.facingDirection.displayString,
      architecturalStyle: entity.architecturalStyle.displayString,
      roofConfiguration: entity.roofConfiguration.displayString,
      wallExterior: entity.wallExterior.displayString,
      rooms: entity.rooms.map((room) => RoomModel.fromEntity(room)).toList(),
      outdoorExtras: entity.outdoorExtras,
      selectedRoomId: entity.selectedRoomId,
      mandateType: entity.mandateType.displayString,
      leadSource: entity.leadSource.displayString,
      syncLightstone: entity.syncLightstone,
      syncLoom: entity.syncLoom,
      ownerFirstName: entity.ownerFirstName,
      ownerLastName: entity.ownerLastName,
      ownerEmail: entity.ownerEmail,
      ownerPhone: entity.ownerPhone,
      ownerIdNumber: entity.ownerIdNumber,
      mandateStart: entity.mandateStart,
      mandateEnd: entity.mandateEnd,
    );
  }

  /// Convert PropertyStateModel to pure PropertyState Domain Entity
  PropertyState toEntity() {
    return PropertyState(
      currentStep: currentStep,
      propertyType: PropertyTypeExtension.fromString(propertyType),
      propertySubtype: PropertySubtypeExtension.fromString(propertySubtype),
      streetAddress: streetAddress,
      suburb: suburb,
      city: city,
      province: province,
      postalCode: postalCode,
      complexName: complexName,
      erfPlotNumber: erfPlotNumber,
      erfSize: erfSize,
      floorArea: floorArea,
      constructionYear: constructionYear,
      maxHeight: maxHeight,
      zoning: zoning,
      facingDirection: FacingDirectionExtension.fromString(facingDirection),
      architecturalStyle: ArchitecturalStyleExtension.fromString(architecturalStyle),
      roofConfiguration: RoofConfigurationExtension.fromString(roofConfiguration),
      wallExterior: WallExteriorExtension.fromString(wallExterior),
      rooms: rooms.map((roomModel) => roomModel.toEntity()).toList(),
      outdoorExtras: outdoorExtras,
      selectedRoomId: selectedRoomId,
      mandateType: MandateTypeExtension.fromString(mandateType),
      leadSource: LeadSourceExtension.fromString(leadSource),
      syncLightstone: syncLightstone,
      syncLoom: syncLoom,
      ownerFirstName: ownerFirstName,
      ownerLastName: ownerLastName,
      ownerEmail: ownerEmail,
      ownerPhone: ownerPhone,
      ownerIdNumber: ownerIdNumber,
      mandateStart: mandateStart,
      mandateEnd: mandateEnd,
    );
  }
}
