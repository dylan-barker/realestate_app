import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dto/listing_dtos.dart';
import '../models/contact.dart';
import '../models/listing_parking.dart';
import '../models/listing_valuation.dart';
import '../models/property_running_costs.dart';
import '../models/property_state.dart';
import '../models/room.dart';

class PropertyRepository {
  final ApiClient _client;

  PropertyRepository(this._client);

  Future<List<Room>> getInitialRooms() async => [];

  Future<void> savePropertyDraft(PropertyState propertyState) async {
    developer.log(
      'Draft saved: Property Type ID: ${propertyState.propertyTypeId}',
    );
  }

  Future<List<ListingSummaryDto>> getAllListings({
    String? status,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final params = <String, dynamic>{};
    if (status != null) params['status'] = status;
    if (dateFrom != null) params['dateFrom'] = dateFrom.toIso8601String();
    if (dateTo != null) params['dateTo'] = dateTo.toIso8601String();

    final response = await _client.get(
      ApiEndpoints.listings,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return (response.data as List).map((e) {
      final j = e as Map<String, dynamic>;
      return ListingSummaryDto(
        id: j['id'] as int,
        referenceNumber: j['referenceNumber'] as String,
        p24Ref: j['p24Ref'] as String?,
        propertyTypeId: j['propertyTypeId'] as int,
        listingValuationId: j['listingValuationId'] as int?,
        listDate: j['listDate'] != null
            ? DateTime.parse(j['listDate'] as String)
            : null,
        status: j['status'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );
    }).toList();
  }

  Future<int> createListing(int propertyTypeId) async {
    final response = await _client.post(
      ApiEndpoints.listings,
      data: {'propertyTypeId': propertyTypeId},
    );
    final json = response.data as Map<String, dynamic>;
    return json['id'] as int;
  }

  Future<PropertyState> loadListing(int listingId) async {
    final response = await _client.get(ApiEndpoints.listing(listingId));
    final j = response.data as Map<String, dynamic>;

    final address = j['address'] as Map<String, dynamic>?;
    final buildingInfo = j['buildingInfo'] as Map<String, dynamic>?;
    final valuation = j['valuation'] as Map<String, dynamic>?;
    final runningCosts = j['runningCosts'] as Map<String, dynamic>?;

    final roomsJson = (j['rooms'] as List<dynamic>?) ?? [];
    final parkingJson = (j['parking'] as List<dynamic>?) ?? [];
    final contactsJson = (j['contacts'] as List<dynamic>?) ?? [];
    final outdoorJson = (j['outdoorFeatures'] as List<dynamic>?) ?? [];

    final contacts = contactsJson
        .map((c) => c as Map<String, dynamic>)
        .map(
          (c) => Contact(
            id: c['id'].toString(),
            fullName: c['fullName'] as String? ?? '',
            idNumber: c['idNumber'] as String? ?? '',
            companyName: c['companyName'] as String? ?? '',
            companyRegistrationNumber:
                c['companyRegistrationNumber'] as String? ?? '',
            mobilePhone: c['mobilePhone'] as String? ?? '',
            emailAddress: c['emailAddress'] as String? ?? '',
            role: c['role'] as String? ?? '',
          ),
        )
        .toList();

    return PropertyState(
      listingId: j['id'] as int?,
      propertyTypeId: j['propertyTypeId'] as int? ?? 0,
      referenceNumber: j['referenceNumber'] as String? ?? '',
      status: j['status'] as String? ?? 'draft',
      p24Ref: j['p24Ref'] as String?,
      streetNumber: address?['streetNumber'] as String? ?? '',
      street: address?['street'] as String? ?? '',
      unitNumber: address?['unitNumber'] as String? ?? '',
      suburb: address?['suburb'] as String? ?? '',
      city: address?['city'] as String? ?? '',
      province: address?['province'] as String? ?? '',
      country: address?['country'] as String? ?? '',
      postalCode: address?['postalCode'] as String? ?? '',
      estateName: address?['estateName'] as String? ?? '',
      erfNumber: address?['erfNumber'] as String? ?? '',
      latitude: (address?['latitude'] as num?)?.toDouble(),
      longitude: (address?['longitude'] as num?)?.toDouble(),
      erfSize: buildingInfo?['erfSize']?.toString() ?? '',
      floorArea: buildingInfo?['floorArea']?.toString() ?? '',
      constructionYear: buildingInfo?['constructionYear']?.toString() ?? '',
      facingId: buildingInfo?['facingId'] as int?,
      zoningId: buildingInfo?['zoningId'] as int?,
      rooms: roomsJson.map((r) => r as Map<String, dynamic>).map((r) {
        final condition = r['condition'] as Map<String, dynamic>?;
        final features =
            (r['features'] as List<dynamic>?)
                ?.map(
                  (f) => (f as Map<String, dynamic>)['description'] as String,
                )
                .toList() ??
            [];
        final customFeatures =
            (r['customFeatures'] as List<dynamic>?)
                ?.map(
                  (f) => (f as Map<String, dynamic>)['description'] as String,
                )
                .toList() ??
            [];
        return Room(
          id: (r['id'] as int).toString(),
          name: r['name'] as String? ?? '',
          roomTypeId: r['roomTypeId'] as int? ?? 1,
          roomTypeOther: r['roomTypeOther'] as String?,
          conditionRating: condition?['conditionRating'] as int?,
          features: [...features, ...customFeatures],
          featureIds: features.map((_) => 0).toList(),
          notes: condition?['notes'] as String? ?? '',
          photoUrl: r['photoUrl'] as String?,
          createdAt: r['createdAt'] != null
              ? DateTime.parse(r['createdAt'] as String)
              : null,
          updatedAt: r['updatedAt'] != null
              ? DateTime.parse(r['updatedAt'] as String)
              : null,
        );
      }).toList(),
      parking: parkingJson
          .map((p) => p as Map<String, dynamic>)
          .map(
            (p) => ListingParking(
              id: p['id'].toString(),
              parkingTypeId: p['parkingTypeId'] as int? ?? 1,
              quantity: p['quantity'] as int? ?? 1,
            ),
          )
          .toList(),
      outdoorFeatures: outdoorJson
          .map((f) => (f as Map<String, dynamic>)['description'] as String)
          .toList(),
      listingValuation: ListingValuation(
        ownersNetPrice: valuation?['ownersNetPrice']?.toString() ?? '',
        agentValuation: valuation?['agentValuation']?.toString() ?? '',
        commissionPercent: valuation?['commissionPercent']?.toString() ?? '',
      ),
      propertyRunningCosts: PropertyRunningCosts(
        monthlyLevy: runningCosts?['monthlyLevy']?.toString() ?? '',
        monthlyRates: runningCosts?['monthlyRates']?.toString() ?? '',
        electricity: runningCosts?['electricity']?.toString() ?? '',
        water: runningCosts?['water']?.toString() ?? '',
      ),
      primaryContact: contacts.isNotEmpty ? contacts.first : const Contact(),
      coContacts: contacts.length > 1 ? contacts.sublist(1) : [],
    );
  }

  Future<void> updatePropertyType(int listingId, int propertyTypeId) async {
    await _client.put(
      ApiEndpoints.listing(listingId),
      data: {'propertyTypeId': propertyTypeId},
    );
  }

  Future<void> upsertAddress(int listingId, PropertyState state) async {
    final data = <String, dynamic>{};
    if (state.streetNumber.isNotEmpty)
      data['streetNumber'] = state.streetNumber;
    if (state.street.isNotEmpty) data['street'] = state.street;
    if (state.unitNumber.isNotEmpty) data['unitNumber'] = state.unitNumber;
    if (state.suburb.isNotEmpty) data['suburb'] = state.suburb;
    if (state.city.isNotEmpty) data['city'] = state.city;
    if (state.province.isNotEmpty) data['province'] = state.province;
    if (state.country.isNotEmpty) data['country'] = state.country;
    if (state.postalCode.isNotEmpty) data['postalCode'] = state.postalCode;
    if (state.estateName.isNotEmpty) data['estateName'] = state.estateName;
    if (state.erfNumber.isNotEmpty) data['erfNumber'] = state.erfNumber;
    if (state.latitude != null) data['latitude'] = state.latitude;
    if (state.longitude != null) data['longitude'] = state.longitude;
    await _client.put(ApiEndpoints.listingAddress(listingId), data: data);
  }

  Future<void> upsertBuildingInfo(int listingId, PropertyState state) async {
    final data = <String, dynamic>{};
    if (state.erfSize.isNotEmpty) {
      data['erfSize'] = num.tryParse(state.erfSize);
    }
    if (state.floorArea.isNotEmpty) {
      data['floorArea'] = num.tryParse(state.floorArea);
    }
    if (state.constructionYear.isNotEmpty) {
      data['constructionYear'] = int.tryParse(state.constructionYear);
    }
    if (state.facingId != null) data['facingId'] = state.facingId;
    if (state.zoningId != null) data['zoningId'] = state.zoningId;
    await _client.put(ApiEndpoints.listingBuildingInfo(listingId), data: data);
  }

  Future<void> upsertValuation(int listingId, PropertyState state) async {
    final data = <String, dynamic>{};
    if (state.listingValuation.ownersNetPrice.isNotEmpty) {
      data['ownersNetPrice'] = _parseDecimal(
        state.listingValuation.ownersNetPrice,
      );
    }
    if (state.listingValuation.agentValuation.isNotEmpty) {
      data['agentValuation'] = _parseDecimal(
        state.listingValuation.agentValuation,
      );
    }
    if (state.listingValuation.commissionPercent.isNotEmpty) {
      data['commissionPercent'] = _parseDecimal(
        state.listingValuation.commissionPercent,
      );
    }
    await _client.put(ApiEndpoints.listingValuation(listingId), data: data);
  }

  Future<void> upsertRunningCosts(int listingId, PropertyState state) async {
    final data = <String, dynamic>{};
    if (state.propertyRunningCosts.monthlyLevy.isNotEmpty) {
      data['monthlyLevy'] = _parseDecimal(
        state.propertyRunningCosts.monthlyLevy,
      );
    }
    if (state.propertyRunningCosts.monthlyRates.isNotEmpty) {
      data['monthlyRates'] = _parseDecimal(
        state.propertyRunningCosts.monthlyRates,
      );
    }
    if (state.propertyRunningCosts.electricity.isNotEmpty) {
      data['electricity'] = _parseDecimal(
        state.propertyRunningCosts.electricity,
      );
    }
    if (state.propertyRunningCosts.water.isNotEmpty) {
      data['water'] = _parseDecimal(state.propertyRunningCosts.water);
    }
    await _client.put(ApiEndpoints.listingRunningCosts(listingId), data: data);
  }

  Future<void> upsertRooms(int listingId, List<Room> rooms) async {
    final existingRoomsJson = await _getRoomsJson(listingId);
    final existingMap = {
      for (final r in existingRoomsJson) (r['id'] as int): r,
    };

    final roomLocalIds = rooms.map((r) => r.id).toSet();

    final toDelete = existingMap.keys
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
              existingRoomsJson.every((e) => e['name'] != room.name))) {
        toCreate.add(room);
      }
    }

    for (final apiId in toDelete) {
      await _client.delete(ApiEndpoints.listingRoom(listingId, apiId));
    }

    for (final room in toCreate) {
      final createdJson = await _createRoom(listingId, room);
      final createdId = createdJson['id'] as int;

      if (room.photoUrl != null && !room.photoUrl!.startsWith('http')) {
        try {
          await _uploadRoomPhoto(listingId, createdId, room.photoUrl!);
        } catch (_) {}
      }

      if (room.conditionRating != null) {
        await _upsertRoomCondition(
          listingId,
          createdId,
          conditionRating: room.conditionRating,
          notes: room.notes.isNotEmpty ? room.notes : null,
        );
      }

      for (final featureId in room.featureIds) {
        await _linkRoomFeature(listingId, createdId, featureId);
      }
    }

    for (final entry in toUpdate) {
      final apiId = entry.key;
      final room = entry.value;
      final existing = existingMap[apiId]!;

      await _updateRoom(listingId, apiId, room);

      if (room.photoUrl != null && !room.photoUrl!.startsWith('http')) {
        try {
          await _uploadRoomPhoto(listingId, apiId, room.photoUrl!);
        } catch (_) {}
      }

      final existingCondition = existing['condition'] as Map<String, dynamic>?;
      if (room.conditionRating !=
              (existingCondition?['conditionRating'] as int?) ||
          room.notes != (existingCondition?['notes'] as String? ?? '')) {
        await _upsertRoomCondition(
          listingId,
          apiId,
          conditionRating: room.conditionRating,
          notes: room.notes.isNotEmpty ? room.notes : null,
        );
      }

      final existingFeatureIds =
          (existing['features'] as List<dynamic>?)
              ?.map((f) => (f as Map<String, dynamic>)['id'] as int)
              .toSet() ??
          <int>{};
      final desiredFeatureIds = room.featureIds.toSet();

      for (final fid in desiredFeatureIds.difference(existingFeatureIds)) {
        await _linkRoomFeature(listingId, apiId, fid);
      }
      for (final fid in existingFeatureIds.difference(desiredFeatureIds)) {
        await _unlinkRoomFeature(listingId, apiId, fid);
      }
    }
  }

  Future<void> upsertParking(
    int listingId,
    List<ListingParking> parking,
  ) async {
    final existingParkingJson = await _getParkingJson(listingId);
    final existingTypeIds = existingParkingJson
        .map((p) => p['parkingTypeId'] as int)
        .toSet();

    for (final p in parking) {
      if (existingTypeIds.contains(p.parkingTypeId)) {
        final existing = existingParkingJson.firstWhere(
          (ep) => ep['parkingTypeId'] == p.parkingTypeId,
        );
        await _client.put(
          ApiEndpoints.listingSingleParking(listingId, existing['id'] as int),
          data: {'quantity': p.quantity},
        );
      } else {
        await _client.post(
          ApiEndpoints.listingParking(listingId),
          data: {'parkingTypeId': p.parkingTypeId, 'quantity': p.quantity},
        );
      }
    }
  }

  Future<void> upsertContacts(
    int listingId,
    Contact primaryContact,
    List<Contact> coContacts,
  ) async {
    final allContacts = [
      if (primaryContact.fullName.isNotEmpty) primaryContact,
      ...coContacts,
    ];
    final existingJson = await _getContactsJson(listingId);

    for (int i = 0; i < allContacts.length; i++) {
      final contact = allContacts[i];

      if (i < existingJson.length) {
        final existingId = existingJson[i]['id'] as int;
        final data = <String, dynamic>{};
        if (contact.fullName.isNotEmpty) data['fullName'] = contact.fullName;
        if (contact.idNumber.isNotEmpty) data['idNumber'] = contact.idNumber;
        if (contact.companyName.isNotEmpty) {
          data['companyName'] = contact.companyName;
        }
        if (contact.companyRegistrationNumber.isNotEmpty) {
          data['companyRegistrationNumber'] = contact.companyRegistrationNumber;
        }
        if (contact.mobilePhone.isNotEmpty) {
          data['mobilePhone'] = contact.mobilePhone;
        }
        if (contact.emailAddress.isNotEmpty) {
          data['emailAddress'] = contact.emailAddress;
        }
        if (contact.role.isNotEmpty) data['role'] = contact.role;
        await _client.put(
          ApiEndpoints.listingSingleContact(listingId, existingId),
          data: data,
        );
      } else {
        final data = <String, dynamic>{};
        if (contact.fullName.isNotEmpty) data['fullName'] = contact.fullName;
        if (contact.idNumber.isNotEmpty) data['idNumber'] = contact.idNumber;
        if (contact.companyName.isNotEmpty) {
          data['companyName'] = contact.companyName;
        }
        if (contact.companyRegistrationNumber.isNotEmpty) {
          data['companyRegistrationNumber'] = contact.companyRegistrationNumber;
        }
        if (contact.mobilePhone.isNotEmpty) {
          data['mobilePhone'] = contact.mobilePhone;
        }
        if (contact.emailAddress.isNotEmpty) {
          data['emailAddress'] = contact.emailAddress;
        }
        if (contact.role.isNotEmpty) data['role'] = contact.role;
        await _client.post(ApiEndpoints.listingContacts(listingId), data: data);
      }
    }
  }

  Future<void> upsertOutdoorFeatures(
    int listingId,
    List<String> outdoorFeatures,
  ) async {
    await _client.put(
      ApiEndpoints.listingOutdoorFeatures(listingId),
      data: {'descriptions': outdoorFeatures},
    );
  }

  Future<void> submitListing(int listingId) async {
    await _client.put(ApiEndpoints.listingSubmit(listingId));
    developer.log('Listing submitted: ID=$listingId');
  }

  Future<void> deleteListing(int listingId) async {
    await _client.delete(ApiEndpoints.listing(listingId));
    developer.log('Listing deleted: ID=$listingId');
  }

  Future<void> uploadRoomPhoto(
    int listingId,
    int roomId,
    String filePath,
  ) async {
    await _uploadRoomPhoto(listingId, roomId, filePath);
  }

  Future<List<Map<String, dynamic>>> _getRoomsJson(int listingId) async {
    final response = await _client.get(ApiEndpoints.listingRooms(listingId));
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> _createRoom(int listingId, Room room) async {
    final data = <String, dynamic>{
      'name': room.name,
      'roomTypeId': room.roomTypeId,
    };
    if (room.roomTypeOther != null) data['roomTypeOther'] = room.roomTypeOther;
    if (room.photoUrl != null) data['photoUrl'] = room.photoUrl;
    final response = await _client.post(
      ApiEndpoints.listingRooms(listingId),
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> _updateRoom(int listingId, int roomId, Room room) async {
    final data = <String, dynamic>{};
    if (room.name.isNotEmpty) data['name'] = room.name;
    data['roomTypeId'] = room.roomTypeId;
    if (room.roomTypeOther != null) data['roomTypeOther'] = room.roomTypeOther;
    if (room.photoUrl != null) data['photoUrl'] = room.photoUrl;
    await _client.put(ApiEndpoints.listingRoom(listingId, roomId), data: data);
  }

  Future<void> _upsertRoomCondition(
    int listingId,
    int roomId, {
    int? conditionRating,
    String? notes,
  }) async {
    final data = <String, dynamic>{'conditionCategoryId': 1};
    if (conditionRating != null) data['conditionRating'] = conditionRating;
    if (notes != null) data['notes'] = notes;
    await _client.put(
      ApiEndpoints.listingRoomCondition(listingId, roomId),
      data: data,
    );
  }

  Future<void> _linkRoomFeature(
    int listingId,
    int roomId,
    int featureId,
  ) async {
    await _client.post(
      ApiEndpoints.listingRoomFeatures(listingId, roomId),
      data: {'featureId': featureId},
    );
  }

  Future<void> _unlinkRoomFeature(
    int listingId,
    int roomId,
    int featureId,
  ) async {
    await _client.delete(
      ApiEndpoints.listingRoomFeature(listingId, roomId, featureId),
    );
  }

  Future<void> _uploadRoomPhoto(
    int listingId,
    int roomId,
    String filePath,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: 'room_photo.jpg',
      ),
    });
    await _client.post(
      ApiEndpoints.listingRoomPhoto(listingId, roomId),
      data: formData,
    );
  }

  Future<List<Map<String, dynamic>>> _getParkingJson(int listingId) async {
    final response = await _client.get(ApiEndpoints.listingParking(listingId));
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _getContactsJson(int listingId) async {
    final response = await _client.get(ApiEndpoints.listingContacts(listingId));
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  num? _parseDecimal(String value) {
    if (value.isEmpty) return null;
    return num.tryParse(value);
  }
}
