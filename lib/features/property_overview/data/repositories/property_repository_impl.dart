import 'dart:developer' as developer;

import '../../../../core/network/dto/address_dtos.dart';
import '../../../../core/network/dto/building_info_dtos.dart';
import '../../../../core/network/dto/contact_dtos.dart';
import '../../../../core/network/dto/listing_dtos.dart';
import '../../../../core/network/dto/outdoor_feature_dtos.dart';
import '../../../../core/network/dto/parking_dtos.dart';
import '../../../../core/network/dto/room_dtos.dart';
import '../../../../core/network/dto/valuation_dtos.dart';
import '../../../../core/network/services/contact_api_service.dart';
import '../../../../core/network/services/listing_api_service.dart';
import '../../../../core/network/services/parking_api_service.dart';
import '../../../../core/network/services/room_api_service.dart';
import '../models/contact.dart';
import '../models/listing_parking.dart';
import '../models/listing_valuation.dart';
import '../models/property_running_costs.dart';
import '../models/property_state.dart';
import '../models/room.dart';
import 'property_repository.dart';

class PropertyRepositoryImpl implements IPropertyRepository {
  final ListingApiService _listingApi;
  final RoomApiService _roomApi;
  final ContactApiService _contactApi;
  final ParkingApiService _parkingApi;

  PropertyRepositoryImpl({
    required ListingApiService listingApi,
    required RoomApiService roomApi,
    required ContactApiService contactApi,
    required ParkingApiService parkingApi,
  }) : _listingApi = listingApi,
       _roomApi = roomApi,
       _contactApi = contactApi,
       _parkingApi = parkingApi;

  @override
  Future<List<Room>> getInitialRooms() async {
    return [];
  }

  @override
  Future<void> savePropertyDraft(PropertyState propertyState) async {
    developer.log(
      'Draft saved: Property Type ID: ${propertyState.propertyTypeId}',
    );
  }

  @override
  Future<int> createListing(int propertyTypeId) async {
    final request = CreateListingRequest(propertyTypeId: propertyTypeId);
    final response = await _listingApi.create(request);
    developer.log(
      'Listing created: ID=${response.id}, Ref=${response.referenceNumber}',
    );
    return response.id;
  }

  @override
  Future<PropertyState> loadListing(int listingId) async {
    final response = await _listingApi.getById(listingId);

    final contacts = response.contacts
        .map(
          (c) => Contact(
            id: c.id.toString(),
            fullName: c.fullName ?? '',
            idNumber: c.idNumber ?? '',
            companyName: c.companyName ?? '',
            companyRegistrationNumber: c.companyRegistrationNumber ?? '',
            mobilePhone: c.mobilePhone ?? '',
            emailAddress: c.emailAddress ?? '',
            role: c.role ?? '',
          ),
        )
        .toList();

    return PropertyState(
      listingId: response.id,
      propertyTypeId: response.propertyTypeId,
      referenceNumber: response.referenceNumber,
      status: response.status,
      p24Ref: response.p24Ref,
      streetNumber: response.address?.streetNumber ?? '',
      street: response.address?.street ?? '',
      unitNumber: response.address?.unitNumber ?? '',
      suburb: response.address?.suburb ?? '',
      city: response.address?.city ?? '',
      province: response.address?.province ?? '',
      country: response.address?.country ?? '',
      postalCode: response.address?.postalCode ?? '',
      estateName: response.address?.estateName ?? '',
      erfNumber: response.address?.erfNumber ?? '',
      latitude: response.address?.latitude?.toDouble(),
      longitude: response.address?.longitude?.toDouble(),
      erfSize: response.buildingInfo?.erfSize?.toString() ?? '',
      floorArea: response.buildingInfo?.floorArea?.toString() ?? '',
      constructionYear:
          response.buildingInfo?.constructionYear?.toString() ?? '',
      facingId: response.buildingInfo?.facingId,
      zoningId: response.buildingInfo?.zoningId,
      rooms: response.rooms
          .map(
            (r) => Room(
              id: r.id.toString(),
              name: r.name,
              roomTypeId: r.roomTypeId,
              roomTypeOther: r.roomTypeOther,
              conditionRating: r.condition?.conditionRating,
              features: [
                ...r.features.map((f) => f.description),
                ...r.customFeatures.map((f) => f.description),
              ],
              featureIds: r.features.map((f) => f.id).toList(),
              notes: r.condition?.notes ?? '',
              photoUrl: r.photoUrl,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            ),
          )
          .toList(),
      parking: response.parking
          .map(
            (p) => ListingParking(
              id: p.id.toString(),
              parkingTypeId: p.parkingTypeId,
              quantity: p.quantity,
            ),
          )
          .toList(),
      outdoorFeatures: response.outdoorFeatures
          .map((f) => f.description)
          .toList(),
      listingValuation: ListingValuation(
        ownersNetPrice: response.valuation?.ownersNetPrice?.toString() ?? '',
        agentValuation: response.valuation?.agentValuation?.toString() ?? '',
        commissionPercent:
            response.valuation?.commissionPercent?.toString() ?? '',
      ),
      propertyRunningCosts: PropertyRunningCosts(
        monthlyLevy: response.runningCosts?.monthlyLevy?.toString() ?? '',
        monthlyRates: response.runningCosts?.monthlyRates?.toString() ?? '',
        electricity: response.runningCosts?.electricity?.toString() ?? '',
        water: response.runningCosts?.water?.toString() ?? '',
      ),
      primaryContact: contacts.isNotEmpty ? contacts.first : const Contact(),
      coContacts: contacts.length > 1 ? contacts.sublist(1) : [],
    );
  }

  @override
  Future<void> updatePropertyType(int listingId, int propertyTypeId) async {
    final request = UpdateListingRequest(propertyTypeId: propertyTypeId);
    await _listingApi.update(listingId, request);
  }

  @override
  Future<void> upsertAddress(int listingId, PropertyState state) async {
    final request = UpsertAddressRequest(
      streetNumber: state.streetNumber.isNotEmpty ? state.streetNumber : null,
      street: state.street.isNotEmpty ? state.street : null,
      unitNumber: state.unitNumber.isNotEmpty ? state.unitNumber : null,
      suburb: state.suburb.isNotEmpty ? state.suburb : null,
      city: state.city.isNotEmpty ? state.city : null,
      province: state.province.isNotEmpty ? state.province : null,
      country: state.country.isNotEmpty ? state.country : null,
      postalCode: state.postalCode.isNotEmpty ? state.postalCode : null,
      estateName: state.estateName.isNotEmpty ? state.estateName : null,
      erfNumber: state.erfNumber.isNotEmpty ? state.erfNumber : null,
      latitude: state.latitude,
      longitude: state.longitude,
    );
    await _listingApi.upsertAddress(listingId, request);
  }

  @override
  Future<void> upsertBuildingInfo(int listingId, PropertyState state) async {
    final request = UpsertBuildingInfoRequest(
      erfSize: state.erfSize.isNotEmpty ? num.tryParse(state.erfSize) : null,
      floorArea: state.floorArea.isNotEmpty
          ? num.tryParse(state.floorArea)
          : null,
      constructionYear: state.constructionYear.isNotEmpty
          ? int.tryParse(state.constructionYear)
          : null,
      facingId: state.facingId,
      zoningId: state.zoningId,
    );
    await _listingApi.upsertBuildingInfo(listingId, request);
  }

  @override
  Future<void> upsertValuation(int listingId, PropertyState state) async {
    final request = UpsertValuationRequest(
      ownersNetPrice: _parseDecimal(state.listingValuation.ownersNetPrice),
      agentValuation: _parseDecimal(state.listingValuation.agentValuation),
      commissionPercent: _parseDecimal(
        state.listingValuation.commissionPercent,
      ),
    );
    await _listingApi.upsertValuation(listingId, request);
  }

  @override
  Future<void> upsertRunningCosts(int listingId, PropertyState state) async {
    final request = UpsertRunningCostsRequest(
      monthlyLevy: _parseDecimal(state.propertyRunningCosts.monthlyLevy),
      monthlyRates: _parseDecimal(state.propertyRunningCosts.monthlyRates),
      electricity: _parseDecimal(state.propertyRunningCosts.electricity),
      water: _parseDecimal(state.propertyRunningCosts.water),
    );
    await _listingApi.upsertRunningCosts(listingId, request);
  }

  @override
  Future<void> upsertRooms(int listingId, List<Room> rooms) async {
    final existingRooms = await _roomApi.getRooms(listingId);
    final existingMap = {for (final r in existingRooms) r.id: r};

    final roomLocalIds = rooms.map((r) => r.id).toSet();
    final roomApiIds = existingRooms.map((r) => r.id).toSet();

    final toDelete = roomApiIds
        .where((id) => !roomLocalIds.contains(id.toString()))
        .toList();
    final toCreate = <Room>[];
    final toUpdate = <MapEntry<int, Room>>[];

    for (final room in rooms) {
      final apiId = int.tryParse(room.id);
      if (apiId != null && existingMap.containsKey(apiId)) {
        toUpdate.add(MapEntry(apiId, room));
      } else if (apiId == null ||
          (!existingMap.containsKey(apiId) &&
              existingRooms.every((e) => e.name != room.name))) {
        toCreate.add(room);
      }
    }

    for (final apiId in toDelete) {
      await _roomApi.deleteRoom(listingId, apiId);
    }

    for (final room in toCreate) {
      final request = CreateRoomRequest(
        name: room.name,
        roomTypeId: room.roomTypeId,
        roomTypeOther: room.roomTypeOther,
        photoUrl: room.photoUrl,
      );
      final created = await _roomApi.createRoom(listingId, request);

      if (room.photoUrl != null && !room.photoUrl!.startsWith('http')) {
        try {
          await _roomApi.uploadPhoto(listingId, created.id, room.photoUrl!);
        } catch (_) {}
      }

      if (room.conditionRating != null) {
        await _roomApi.upsertCondition(
          listingId,
          created.id,
          UpsertRoomConditionRequest(
            conditionRating: room.conditionRating,
            notes: room.notes.isNotEmpty ? room.notes : null,
            conditionCategoryId: 1,
          ),
        );
      }

      for (final featureId in room.featureIds) {
        await _roomApi.linkFeature(listingId, created.id, featureId);
      }
    }

    for (final entry in toUpdate) {
      final apiId = entry.key;
      final room = entry.value;
      final existing = existingMap[apiId]!;

      await _roomApi.updateRoom(
        listingId,
        apiId,
        UpdateRoomRequest(
          name: room.name.isNotEmpty ? room.name : null,
          roomTypeId: room.roomTypeId,
          roomTypeOther: room.roomTypeOther,
          photoUrl: room.photoUrl,
        ),
      );

      if (room.photoUrl != null && !room.photoUrl!.startsWith('http')) {
        try {
          await _roomApi.uploadPhoto(listingId, apiId, room.photoUrl!);
        } catch (_) {}
      }

      if (room.conditionRating != existing.condition?.conditionRating ||
          room.notes != (existing.condition?.notes ?? '')) {
        await _roomApi.upsertCondition(
          listingId,
          apiId,
          UpsertRoomConditionRequest(
            conditionRating: room.conditionRating,
            notes: room.notes.isNotEmpty ? room.notes : null,
            conditionCategoryId: 1,
          ),
        );
      }

      final existingFeatureIds = existing.features.map((f) => f.id).toSet();
      final desiredFeatureIds = room.featureIds.toSet();

      for (final fid in desiredFeatureIds.difference(existingFeatureIds)) {
        await _roomApi.linkFeature(listingId, apiId, fid);
      }
      for (final fid in existingFeatureIds.difference(desiredFeatureIds)) {
        await _roomApi.unlinkFeature(listingId, apiId, fid);
      }
    }
  }

  @override
  Future<void> upsertParking(
    int listingId,
    List<ListingParking> parking,
  ) async {
    final existingParking = await _parkingApi.getParking(listingId);
    final existingTypeIds = existingParking.map((p) => p.parkingTypeId).toSet();

    for (final p in parking) {
      if (existingTypeIds.contains(p.parkingTypeId)) {
        final existing = existingParking.firstWhere(
          (ep) => ep.parkingTypeId == p.parkingTypeId,
        );
        await _parkingApi.updateParking(
          listingId,
          existing.id,
          UpdateParkingRequest(quantity: p.quantity),
        );
      } else {
        await _parkingApi.addParking(
          listingId,
          AddParkingRequest(
            parkingTypeId: p.parkingTypeId,
            quantity: p.quantity,
          ),
        );
      }
    }
  }

  @override
  Future<void> upsertContacts(
    int listingId,
    Contact primaryContact,
    List<Contact> coContacts,
  ) async {
    final allContacts = [
      if (primaryContact.fullName.isNotEmpty) primaryContact,
      ...coContacts,
    ];
    final existingContacts = await _contactApi.getContacts(listingId);

    for (int i = 0; i < allContacts.length; i++) {
      final contact = allContacts[i];

      if (i < existingContacts.length) {
        final request = UpdateContactRequest(
          fullName: contact.fullName.isNotEmpty ? contact.fullName : null,
          idNumber: contact.idNumber.isNotEmpty ? contact.idNumber : null,
          companyName: contact.companyName.isNotEmpty
              ? contact.companyName
              : null,
          companyRegistrationNumber:
              contact.companyRegistrationNumber.isNotEmpty
              ? contact.companyRegistrationNumber
              : null,
          mobilePhone: contact.mobilePhone.isNotEmpty
              ? contact.mobilePhone
              : null,
          emailAddress: contact.emailAddress.isNotEmpty
              ? contact.emailAddress
              : null,
          role: contact.role.isNotEmpty ? contact.role : null,
        );
        await _contactApi.updateContact(
          listingId,
          existingContacts[i].id,
          request,
        );
      } else {
        final request = AddContactRequest(
          fullName: contact.fullName.isNotEmpty ? contact.fullName : null,
          idNumber: contact.idNumber.isNotEmpty ? contact.idNumber : null,
          companyName: contact.companyName.isNotEmpty
              ? contact.companyName
              : null,
          companyRegistrationNumber:
              contact.companyRegistrationNumber.isNotEmpty
              ? contact.companyRegistrationNumber
              : null,
          mobilePhone: contact.mobilePhone.isNotEmpty
              ? contact.mobilePhone
              : null,
          emailAddress: contact.emailAddress.isNotEmpty
              ? contact.emailAddress
              : null,
          role: contact.role.isNotEmpty ? contact.role : null,
        );
        await _contactApi.addContact(listingId, request);
      }
    }
  }

  @override
  Future<void> upsertOutdoorFeatures(
    int listingId,
    List<String> outdoorFeatures,
  ) async {
    await _listingApi.upsertOutdoorFeatures(
      listingId,
      UpsertOutdoorFeaturesRequest(descriptions: outdoorFeatures),
    );
  }

  @override
  Future<void> submitListing(int listingId) async {
    await _listingApi.submit(listingId);
    developer.log('Listing submitted: ID=$listingId');
  }

  @override
  Future<void> deleteListing(int listingId) async {
    await _listingApi.delete(listingId);
    developer.log('Listing deleted: ID=$listingId');
  }

  @override
  Future<void> uploadRoomPhoto(
    int listingId,
    int roomId,
    String filePath,
  ) async {
    await _roomApi.uploadPhoto(listingId, roomId, filePath);
  }

  num? _parseDecimal(String value) {
    if (value.isEmpty) return null;
    return num.tryParse(value);
  }
}
