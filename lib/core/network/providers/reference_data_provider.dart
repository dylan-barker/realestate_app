import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/lookup_dtos.dart';
import '../services/reference_data_service.dart';
import 'api_providers.dart';

final referenceDataServiceProvider = Provider<ReferenceDataService>((ref) {
  final lookupApi = ref.watch(lookupApiServiceProvider);
  return ReferenceDataService(lookupApi);
});

final referenceDataLoadedProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(referenceDataServiceProvider);
  await service.loadAll();
});

final propertyTypesProvider = Provider<List<PropertyTypeDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).propertyTypes;
});

final roomTypesProvider = Provider<List<RoomTypeDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).roomTypes;
});

final featuresProvider = Provider<List<FeatureDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).features;
});

final conditionCategoriesProvider = Provider<List<ConditionCategoryDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).conditionCategories;
});

final parkingTypesProvider = Provider<List<ParkingTypeDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).parkingTypes;
});

final facingDirectionsProvider = Provider<List<FacingDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).facingDirections;
});

final zoningClassificationsProvider = Provider<List<ZoningDto>>((ref) {
  ref.watch(referenceDataLoadedProvider);
  return ref.watch(referenceDataServiceProvider).zoningClassifications;
});
