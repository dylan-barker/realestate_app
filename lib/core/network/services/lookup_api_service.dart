import '../api_client.dart';
import '../api_endpoints.dart';
import '../dto/lookup_dtos.dart';

class LookupApiService {
  final ApiClient _client;

  LookupApiService(this._client);

  Future<List<PropertyTypeDto>> getPropertyTypes() async {
    final response = await _client.get(ApiEndpoints.propertyTypes);
    return _parseList(response.data, _parsePropertyType);
  }

  Future<List<RoomTypeDto>> getRoomTypes() async {
    final response = await _client.get(ApiEndpoints.roomTypes);
    return _parseList(response.data, _parseRoomType);
  }

  Future<List<FeatureDto>> getFeatures() async {
    final response = await _client.get(ApiEndpoints.features);
    return _parseList(response.data, _parseFeature);
  }

  Future<List<ConditionCategoryDto>> getConditionCategories() async {
    final response = await _client.get(ApiEndpoints.conditionCategories);
    return _parseList(response.data, _parseConditionCategory);
  }

  Future<List<ParkingTypeDto>> getParkingTypes() async {
    final response = await _client.get(ApiEndpoints.parkingTypes);
    return _parseList(response.data, _parseParkingType);
  }

  Future<List<FacingDto>> getFacing() async {
    final response = await _client.get(ApiEndpoints.facing);
    return _parseList(response.data, _parseFacing);
  }

  Future<List<ZoningDto>> getZoning() async {
    final response = await _client.get(ApiEndpoints.zoning);
    return _parseList(response.data, _parseZoning);
  }

  List<T> _parseList<T>(dynamic data, T Function(Map<String, dynamic>) parser) {
    return (data as List)
        .map((e) => parser(e as Map<String, dynamic>))
        .toList();
  }

  static PropertyTypeDto _parsePropertyType(Map<String, dynamic> j) =>
      PropertyTypeDto(
        id: j['id'] as int,
        name: j['name'] as String,
        sortOrder: j['sortOrder'] as int,
        isActive: j['isActive'] as bool,
      );

  static RoomTypeDto _parseRoomType(Map<String, dynamic> j) =>
      RoomTypeDto(id: j['id'] as int, description: j['description'] as String);

  static FeatureDto _parseFeature(Map<String, dynamic> j) => FeatureDto(
    id: j['id'] as int,
    category: j['category'] as String,
    description: j['description'] as String,
  );

  static ConditionCategoryDto _parseConditionCategory(Map<String, dynamic> j) =>
      ConditionCategoryDto(
        id: j['id'] as int,
        description: j['description'] as String,
      );

  static ParkingTypeDto _parseParkingType(Map<String, dynamic> j) =>
      ParkingTypeDto(
        id: j['id'] as int,
        description: j['description'] as String,
      );

  static FacingDto _parseFacing(Map<String, dynamic> j) =>
      FacingDto(id: j['id'] as int, description: j['description'] as String);

  static ZoningDto _parseZoning(Map<String, dynamic> j) =>
      ZoningDto(id: j['id'] as int, description: j['description'] as String);
}
