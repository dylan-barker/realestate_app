import 'property_state.dart';
import 'enums/architectural_style.dart';
import 'enums/entity_type.dart';
import 'enums/facing_direction.dart';
import 'enums/lead_source.dart';
import 'enums/mandate_type.dart';
import 'enums/property_subtype.dart';
import 'enums/property_type.dart';
import 'enums/roof_configuration.dart';
import 'enums/wall_exterior.dart';
import 'outdoor_extra_item.dart';
import 'owner.dart';
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
  final List<OutdoorExtraItem> outdoorExtras;
  final String? selectedRoomId;
  final String mandateType;
  final String leadSource;
  final bool syncLightstone;
  final bool syncLoom;
  final Map<String, dynamic> primaryOwner;
  final List<Map<String, dynamic>> coOwners;
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
    required this.primaryOwner,
    required this.coOwners,
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
      outdoorExtras: entity.outdoorExtras.map((e) => OutdoorExtraItem(name: e.name, quantity: e.quantity)).toList(),
      selectedRoomId: entity.selectedRoomId,
      mandateType: entity.mandateType.displayString,
      leadSource: entity.leadSource.displayString,
      syncLightstone: entity.syncLightstone,
      syncLoom: entity.syncLoom,
      primaryOwner: _toOwnerMap(entity.primaryOwner),
      coOwners: entity.coOwners.map(_toOwnerMap).toList(),
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
      outdoorExtras: outdoorExtras.map((e) => OutdoorExtraItem(name: e.name, quantity: e.quantity)).toList(),
      selectedRoomId: selectedRoomId,
      mandateType: MandateTypeExtension.fromString(mandateType),
      leadSource: LeadSourceExtension.fromString(leadSource),
      syncLightstone: syncLightstone,
      syncLoom: syncLoom,
      primaryOwner: _ownerFromMap(primaryOwner),
      coOwners: coOwners.map((m) => _ownerFromMap(m)).toList(),
      mandateStart: mandateStart,
      mandateEnd: mandateEnd,
    );
  }

  static Owner _ownerFromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'] as String? ?? '',
      entityType: EntityTypeExtension.fromString(map['entityType'] as String? ?? ''),
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      companyName: map['companyName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      idNumber: map['idNumber'] as String? ?? '',
      registrationNumber: map['registrationNumber'] as String? ?? '',
    );
  }

  static Map<String, dynamic> _toOwnerMap(Owner owner) {
    return {
      'id': owner.id,
      'entityType': owner.entityType.name,
      'firstName': owner.firstName,
      'lastName': owner.lastName,
      'companyName': owner.companyName,
      'email': owner.email,
      'phone': owner.phone,
      'idNumber': owner.idNumber,
      'registrationNumber': owner.registrationNumber,
    };
  }
}
