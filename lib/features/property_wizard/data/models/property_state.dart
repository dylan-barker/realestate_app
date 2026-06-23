import 'contact.dart';
import 'listing_parking.dart';
import 'listing_valuation.dart';
import 'property_running_costs.dart';
import 'room.dart';

class PropertyState {
  final int currentStep;
  final String? selectedRoomId;

  // Step 1: Property Type
  final int propertyTypeId;

  // Step 2: Address & Identification
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

  // Step 5: Valuation & Running Costs
  final ListingValuation listingValuation;
  final PropertyRunningCosts propertyRunningCosts;

  // Step 6: Contacts
  final Contact primaryContact;
  final List<Contact> coContacts;

  // Listing metadata
  final String referenceNumber;
  final String status;
  final String? p24Ref;

  PropertyState({
    this.currentStep = 1,
    this.selectedRoomId,
    this.propertyTypeId = 1,
    this.streetNumber = '',
    this.street = '124 Some Street',
    this.unitNumber = '',
    this.suburb = 'Strand',
    this.city = 'Cape Town',
    this.province = 'Western Cape',
    this.country = 'South Africa',
    this.postalCode = '7140',
    this.estateName = '',
    this.erfNumber = '',
    this.latitude,
    this.longitude,
    this.erfSize = '',
    this.floorArea = '',
    this.constructionYear = '',
    this.facingId,
    this.zoningId,
    this.rooms = const [],
    this.parking = const [],
    this.listingValuation = const ListingValuation(),
    this.propertyRunningCosts = const PropertyRunningCosts(),
    this.primaryContact = const Contact(),
    this.coContacts = const [],
    this.referenceNumber = '',
    this.status = 'draft',
    this.p24Ref,
  });

  PropertyState copyWith({
    int? currentStep,
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
    ListingValuation? listingValuation,
    PropertyRunningCosts? propertyRunningCosts,
    Contact? primaryContact,
    List<Contact>? coContacts,
    String? referenceNumber,
    String? status,
    String? p24Ref,
  }) {
    return PropertyState(
      currentStep: currentStep ?? this.currentStep,
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
      rooms: rooms ?? this.rooms,
      parking: parking ?? this.parking,
      listingValuation: listingValuation ?? this.listingValuation,
      propertyRunningCosts: propertyRunningCosts ?? this.propertyRunningCosts,
      primaryContact: primaryContact ?? this.primaryContact,
      coContacts: coContacts ?? this.coContacts,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      p24Ref: p24Ref ?? this.p24Ref,
    );
  }
}
