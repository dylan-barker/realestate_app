import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../actions/address_actions.dart';
import '../actions/building_info_actions.dart';
import '../actions/mandate_contacts_actions.dart';
import '../actions/property_features_actions.dart';
import '../actions/property_type_actions.dart';
import '../actions/room_details_actions.dart';
import '../actions/wizard_step_actions.dart';
import '../data/data_sources/property_local_data_source.dart';
import '../data/models/enums/architectural_style.dart';
import '../data/models/enums/facing_direction.dart';
import '../data/models/enums/lead_source.dart';
import '../data/models/enums/mandate_type.dart';
import '../data/models/enums/outdoor_extra.dart';
import '../data/models/enums/property_subtype.dart';
import '../data/models/enums/property_type.dart';
import '../data/models/enums/room_category.dart';
import '../data/models/enums/roof_configuration.dart';
import '../data/models/enums/wall_exterior.dart';
import '../data/models/owner.dart';
import '../data/models/property_state.dart';
import '../data/repositories/property_repository.dart';
import '../data/repositories/property_repository_impl.dart';

final propertyLocalDataSourceProvider =
    Provider.autoDispose<PropertyLocalDataSource>((ref) {
  return PropertyLocalDataSource();
});

final propertyRepositoryProvider =
    Provider.autoDispose<IPropertyRepository>((ref) {
  final dataSource = ref.watch(propertyLocalDataSourceProvider);
  return PropertyRepositoryImpl(dataSource);
});

final propertyViewModelProvider =
    NotifierProvider.autoDispose<PropertyViewModel, PropertyState>(() {
  return PropertyViewModel();
});

class PropertyViewModel extends Notifier<PropertyState> {
  late final IPropertyRepository _repository;

  @override
  PropertyState build() {
    _repository = ref.watch(propertyRepositoryProvider);
    _loadInitialData();
    return PropertyState(rooms: const [], outdoorExtras: const []);
  }

  Future<void> _loadInitialData() async {
    try {
      final rooms = await _repository.getInitialRooms();
      final outdoorExtras = await _repository.getInitialOutdoorExtras();
      state = state.copyWith(rooms: rooms, outdoorExtras: outdoorExtras);
    } catch (e) {
      state = state.copyWith(rooms: const [], outdoorExtras: const []);
    }
  }

  void setStep(int step) {
    state = state.withStep(step);
  }

  void nextStep() {
    state = state.withNextStep();
  }

  void prevStep() {
    state = state.withPrevStep();
  }

  void selectPropertyType(PropertyType type) {
    state = state.withPropertyType(type);
  }

  void selectPropertySubtype(PropertySubtype subtype) {
    state = state.withPropertySubtype(subtype);
  }

  void updateAddress({
    String? streetAddress,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
  }) {
    state = state.withAddress(
      streetAddress: streetAddress,
      suburb: suburb,
      city: city,
      province: province,
      postalCode: postalCode,
    );
  }

  void updateIdentifiers({String? complexName, String? erfPlotNumber}) {
    state = state.withIdentifiers(
      complexName: complexName,
      erfPlotNumber: erfPlotNumber,
    );
  }

  void updateTechnicalSpecs({
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
  }) {
    state = state.withTechnicalSpecs(
      erfSize: erfSize,
      floorArea: floorArea,
      constructionYear: constructionYear,
      maxHeight: maxHeight,
      zoning: zoning,
    );
  }

  void selectFacingDirection(FacingDirection direction) {
    state = state.withFacingDirection(direction);
  }

  void selectArchitecturalStyle(ArchitecturalStyle style) {
    state = state.withArchitecturalStyle(style);
  }

  void selectRoofConfiguration(RoofConfiguration config) {
    state = state.withRoofConfig(config);
  }

  void selectWallExterior(WallExterior wall) {
    state = state.withWallExterior(wall);
  }

  void addCustomRoom(String name, RoomCategory category) {
    state = state.withAddedRoom(name, category);
  }

  void removeRoom(String roomId) {
    state = state.withRemovedRoom(roomId);
  }

  void addOutdoorExtra(String name, {OutdoorExtraCategory? category}) {
    state = state.withAddedOutdoorExtra(name, category: category);
  }

  void removeOutdoorExtra(String name) {
    state = state.withRemovedOutdoorExtra(name);
  }

  void incrementOutdoorQuantity(String name) {
    state = state.withIncrementedOutdoorQty(name);
  }

  void decrementOutdoorQuantity(String name) {
    state = state.withDecrementedOutdoorQty(name);
  }

  void selectRoomForEditing(String? roomId) {
    state = state.withSelectedRoom(roomId);
  }

  void updateRoomDetails({
    required String roomId,
    int? conditionRating,
    List<String>? features,
    String? notes,
    String? imagePath,
  }) {
    state = state.withUpdatedRoomDetails(
      roomId: roomId,
      conditionRating: conditionRating,
      features: features,
      notes: notes,
      imagePath: imagePath,
    );
  }

  void renameRoom(String roomId, String newName) {
    state = state.withRenamedRoom(roomId, newName);
  }

  void addFeatureToRoom(String roomId, String feature) {
    state = state.withAddedFeature(roomId, feature);
  }

  void removeFeatureFromRoom(String roomId, String feature) {
    state = state.withRemovedFeature(roomId, feature);
  }

  void selectMandateType(MandateType type) {
    state = state.withMandateType(type);
  }

  void selectLeadSource(LeadSource source) {
    state = state.withLeadSource(source);
  }

  void toggleSyncLightstone(bool value) {
    state = state.withSyncLightstone(value);
  }

  void toggleSyncLoom(bool value) {
    state = state.withSyncLoom(value);
  }

  void updatePrimaryOwner(Owner owner) {
    state = state.withPrimaryOwner(owner);
  }

  void addCoOwner() {
    state = state.withAddedCoOwner();
  }

  void updateCoOwner(int index, Owner owner) {
    state = state.withUpdatedCoOwner(index, owner);
  }

  void removeCoOwner(String id) {
    state = state.withRemovedCoOwner(id);
  }

  void updateMandateDates({String? start, String? end}) {
    state = state.withMandateDates(start: start, end: end);
  }

  Future<void> saveDraft() async {
    await _repository.savePropertyDraft(state);
  }
}
