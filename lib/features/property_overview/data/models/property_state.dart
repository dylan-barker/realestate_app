import 'contact.dart';
import 'listing_parking.dart';
import 'listing_valuation.dart';
import 'property_running_costs.dart';
import 'room.dart';

class PropertyState {
  final String? selectedRoomId;

  // Property Type
  final int propertyTypeId;

  // Address & Identification
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

  // Step 3: Building Info
  final String erfSize;
  final String floorArea;
  final String constructionYear;
  final int? facingId;
  final int? zoningId;

  // Step 4: Property Features
  final List<Room> rooms;
  final List<ListingParking> parking;
  final List<String> outdoorFeatures;

  // Step 5: Valuation & Running Costs
  final ListingValuation listingValuation;
  final PropertyRunningCosts propertyRunningCosts;

  // Step 6: Contacts
  final Contact primaryContact;
  final List<Contact> coContacts;

  // API metadata
  final int? listingId;

  // Listing metadata
  final String referenceNumber;
  final String status;
  final String? p24Ref;
  final String? errorMessage;

  PropertyState({
    this.selectedRoomId,
    this.propertyTypeId = 0,
    this.streetNumber = '',
    this.street = '',
    this.unitNumber = '',
    this.suburb = '',
    this.city = '',
    this.province = '',
    this.country = '',
    this.postalCode = '',
    this.estateName = '',
    this.erfNumber = '',
    this.latitude,
    this.longitude,
    this.erfSize = '',
    this.floorArea = '',
    this.constructionYear = '',
    this.facingId,
    this.zoningId,
    this.listingId,
    this.rooms = const [],
    this.parking = const [],
    this.outdoorFeatures = const [],
    this.listingValuation = const ListingValuation(),
    this.propertyRunningCosts = const PropertyRunningCosts(),
    this.primaryContact = const Contact(),
    this.coContacts = const [],
    this.referenceNumber = '',
    this.status = 'draft',
    this.p24Ref,
    this.errorMessage,
  });

  PropertyState copyWith({
    String? selectedRoomId,
    int? propertyTypeId,
    String? streetNumber,
    String? street,
    String? unitNumber,
    String? suburb,
    String? city,
    String? province,
    String? country,
    String? postalCode,
    String? estateName,
    String? erfNumber,
    double? latitude,
    double? longitude,
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    int? facingId,
    int? zoningId,
    List<Room>? rooms,
    List<ListingParking>? parking,
    List<String>? outdoorFeatures,
    ListingValuation? listingValuation,
    PropertyRunningCosts? propertyRunningCosts,
    Contact? primaryContact,
    List<Contact>? coContacts,
    int? listingId,
    String? referenceNumber,
    String? status,
    String? p24Ref,
    String? errorMessage,
  }) {
    return PropertyState(
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      streetNumber: streetNumber ?? this.streetNumber,
      street: street ?? this.street,
      unitNumber: unitNumber ?? this.unitNumber,
      suburb: suburb ?? this.suburb,
      city: city ?? this.city,
      province: province ?? this.province,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      estateName: estateName ?? this.estateName,
      erfNumber: erfNumber ?? this.erfNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      erfSize: erfSize ?? this.erfSize,
      floorArea: floorArea ?? this.floorArea,
      constructionYear: constructionYear ?? this.constructionYear,
      facingId: facingId ?? this.facingId,
      zoningId: zoningId ?? this.zoningId,
      listingId: listingId ?? this.listingId,
      rooms: rooms ?? this.rooms,
      parking: parking ?? this.parking,
      outdoorFeatures: outdoorFeatures ?? this.outdoorFeatures,
      listingValuation: listingValuation ?? this.listingValuation,
      propertyRunningCosts: propertyRunningCosts ?? this.propertyRunningCosts,
      primaryContact: primaryContact ?? this.primaryContact,
      coContacts: coContacts ?? this.coContacts,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      p24Ref: p24Ref ?? this.p24Ref,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
