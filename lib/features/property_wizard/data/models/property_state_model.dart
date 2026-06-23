import 'contact.dart';
import 'listing_parking.dart';
import 'listing_valuation.dart';
import 'property_running_costs.dart';
import 'property_state.dart';
import 'room_model.dart';

class PropertyStateModel {
  final int currentStep;
  final String? selectedRoomId;
  final int propertyTypeId;
  final String streetNumber;
  final String street;
  final String unitNumber;
  final String suburb;
  final String city;
  final String province;
  final String country;
  final String postalCode;
  final String estateName;
  final String erfNumber;
  final double? latitude;
  final double? longitude;
  final String erfSize;
  final String floorArea;
  final String constructionYear;
  final int? facingId;
  final int? zoningId;
  final List<RoomModel> rooms;
  final List<Map<String, dynamic>> parking;
  final Map<String, dynamic> listingValuation;
  final Map<String, dynamic> propertyRunningCosts;
  final Map<String, dynamic> primaryContact;
  final List<Map<String, dynamic>> coContacts;
  final String referenceNumber;
  final String status;
  final String? p24Ref;

  PropertyStateModel({
    required this.currentStep,
    this.selectedRoomId,
    required this.propertyTypeId,
    required this.streetNumber,
    required this.street,
    required this.unitNumber,
    required this.suburb,
    required this.city,
    required this.province,
    required this.country,
    required this.postalCode,
    required this.estateName,
    required this.erfNumber,
    this.latitude,
    this.longitude,
    required this.erfSize,
    required this.floorArea,
    required this.constructionYear,
    this.facingId,
    this.zoningId,
    required this.rooms,
    required this.parking,
    required this.listingValuation,
    required this.propertyRunningCosts,
    required this.primaryContact,
    required this.coContacts,
    required this.referenceNumber,
    required this.status,
    this.p24Ref,
  });

  factory PropertyStateModel.fromEntity(PropertyState entity) {
    return PropertyStateModel(
      currentStep: entity.currentStep,
      selectedRoomId: entity.selectedRoomId,
      propertyTypeId: entity.propertyTypeId,
      streetNumber: entity.streetNumber,
      street: entity.street,
      unitNumber: entity.unitNumber,
      suburb: entity.suburb,
      city: entity.city,
      province: entity.province,
      country: entity.country,
      postalCode: entity.postalCode,
      estateName: entity.estateName,
      erfNumber: entity.erfNumber,
      latitude: entity.latitude,
      longitude: entity.longitude,
      erfSize: entity.erfSize,
      floorArea: entity.floorArea,
      constructionYear: entity.constructionYear,
      facingId: entity.facingId,
      zoningId: entity.zoningId,
      rooms: entity.rooms.map((r) => RoomModel.fromEntity(r)).toList(),
      parking: entity.parking.map(_parkingToMap).toList(),
      listingValuation: _valuationToMap(entity.listingValuation),
      propertyRunningCosts: _costsToMap(entity.propertyRunningCosts),
      primaryContact: _contactToMap(entity.primaryContact),
      coContacts: entity.coContacts.map(_contactToMap).toList(),
      referenceNumber: entity.referenceNumber,
      status: entity.status,
      p24Ref: entity.p24Ref,
    );
  }

  PropertyState toEntity() {
    return PropertyState(
      currentStep: currentStep,
      selectedRoomId: selectedRoomId,
      propertyTypeId: propertyTypeId,
      streetNumber: streetNumber,
      street: street,
      unitNumber: unitNumber,
      suburb: suburb,
      city: city,
      province: province,
      country: country,
      postalCode: postalCode,
      estateName: estateName,
      erfNumber: erfNumber,
      latitude: latitude,
      longitude: longitude,
      erfSize: erfSize,
      floorArea: floorArea,
      constructionYear: constructionYear,
      facingId: facingId,
      zoningId: zoningId,
      rooms: rooms.map((m) => m.toEntity()).toList(),
      parking: parking.map(_parkingFromMap).toList(),
      listingValuation: _valuationFromMap(listingValuation),
      propertyRunningCosts: _costsFromMap(propertyRunningCosts),
      primaryContact: _contactFromMap(primaryContact),
      coContacts: coContacts.map(_contactFromMap).toList(),
      referenceNumber: referenceNumber,
      status: status,
      p24Ref: p24Ref,
    );
  }

  static Map<String, dynamic> _contactToMap(Contact c) => {
        'id': c.id,
        'fullName': c.fullName,
        'idNumber': c.idNumber,
        'companyName': c.companyName,
        'companyRegistrationNumber': c.companyRegistrationNumber,
        'mobilePhone': c.mobilePhone,
        'emailAddress': c.emailAddress,
        'role': c.role,
      };

  static Contact _contactFromMap(Map<String, dynamic> m) => Contact(
        id: m['id'] as String? ?? '',
        fullName: m['fullName'] as String? ?? '',
        idNumber: m['idNumber'] as String? ?? '',
        companyName: m['companyName'] as String? ?? '',
        companyRegistrationNumber: m['companyRegistrationNumber'] as String? ?? '',
        mobilePhone: m['mobilePhone'] as String? ?? '',
        emailAddress: m['emailAddress'] as String? ?? '',
        role: m['role'] as String? ?? '',
      );

  static Map<String, dynamic> _parkingToMap(ListingParking p) => {
        'id': p.id,
        'parkingTypeId': p.parkingTypeId,
        'quantity': p.quantity,
      };

  static ListingParking _parkingFromMap(Map<String, dynamic> m) => ListingParking(
        id: m['id'] as String? ?? '',
        parkingTypeId: m['parkingTypeId'] as int? ?? 1,
        quantity: m['quantity'] as int? ?? 1,
      );

  static Map<String, dynamic> _valuationToMap(ListingValuation v) => {
        'ownersNetPrice': v.ownersNetPrice,
        'agentValuation': v.agentValuation,
        'commissionPercent': v.commissionPercent,
      };

  static ListingValuation _valuationFromMap(Map<String, dynamic> m) => ListingValuation(
        ownersNetPrice: m['ownersNetPrice'] as String? ?? '',
        agentValuation: m['agentValuation'] as String? ?? '',
        commissionPercent: m['commissionPercent'] as String? ?? '',
      );

  static Map<String, dynamic> _costsToMap(PropertyRunningCosts c) => {
        'monthlyLevy': c.monthlyLevy,
        'monthlyRates': c.monthlyRates,
        'electricity': c.electricity,
        'water': c.water,
      };

  static PropertyRunningCosts _costsFromMap(Map<String, dynamic> m) => PropertyRunningCosts(
        monthlyLevy: m['monthlyLevy'] as String? ?? '',
        monthlyRates: m['monthlyRates'] as String? ?? '',
        electricity: m['electricity'] as String? ?? '',
        water: m['water'] as String? ?? '',
      );
}
