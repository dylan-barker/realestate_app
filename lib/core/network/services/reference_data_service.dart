import 'lookup_api_service.dart';
import '../dto/lookup_dtos.dart';

class ReferenceDataService {
  final LookupApiService _lookupApi;

  ReferenceDataService(this._lookupApi);

  List<PropertyTypeDto> _propertyTypes = [];
  List<RoomTypeDto> _roomTypes = [];
  List<FeatureDto> _features = [];
  List<ConditionCategoryDto> _conditionCategories = [];
  List<ParkingTypeDto> _parkingTypes = [];
  List<FacingDto> _facingDirections = [];
  List<ZoningDto> _zoningClassifications = [];

  List<PropertyTypeDto> get propertyTypes => _propertyTypes;
  List<RoomTypeDto> get roomTypes => _roomTypes;
  List<FeatureDto> get features => _features;
  List<ConditionCategoryDto> get conditionCategories => _conditionCategories;
  List<ParkingTypeDto> get parkingTypes => _parkingTypes;
  List<FacingDto> get facingDirections => _facingDirections;
  List<ZoningDto> get zoningClassifications => _zoningClassifications;

  Future<void> loadAll() async {
    try {
      final results = await Future.wait([
        _lookupApi.getPropertyTypes(),
        _lookupApi.getRoomTypes(),
        _lookupApi.getFeatures(),
        _lookupApi.getConditionCategories(),
        _lookupApi.getParkingTypes(),
        _lookupApi.getFacing(),
        _lookupApi.getZoning(),
      ]);

      _propertyTypes = results[0] as List<PropertyTypeDto>;
      _roomTypes = results[1] as List<RoomTypeDto>;
      _features = results[2] as List<FeatureDto>;
      _conditionCategories = results[3] as List<ConditionCategoryDto>;
      _parkingTypes = results[4] as List<ParkingTypeDto>;
      _facingDirections = results[5] as List<FacingDto>;
      _zoningClassifications = results[6] as List<ZoningDto>;
    } catch (_) {
      // If API is unavailable, leave lists empty
    }
  }
}
