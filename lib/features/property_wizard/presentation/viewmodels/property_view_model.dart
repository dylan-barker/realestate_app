import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/property_local_data_source.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/entities/property_state.dart';
import '../../domain/entities/room.dart';
import '../../domain/enums/architectural_style.dart';
import '../../domain/enums/facing_direction.dart';
import '../../domain/enums/lead_source.dart';
import '../../domain/enums/mandate_type.dart';
import '../../domain/enums/property_subtype.dart';
import '../../domain/enums/property_type.dart';
import '../../domain/enums/roof_configuration.dart';
import '../../domain/enums/room_category.dart';
import '../../domain/enums/wall_exterior.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/usecases/get_initial_rooms.dart';
import '../../domain/usecases/save_property_draft.dart';

// dependency injection providers
final propertyLocalDataSourceProvider = Provider<PropertyLocalDataSource>((ref) {
  return PropertyLocalDataSource();
});

final propertyRepositoryProvider = Provider<IPropertyRepository>((ref) {
  final dataSource = ref.watch(propertyLocalDataSourceProvider);
  return PropertyRepositoryImpl(dataSource);
});

final getInitialRoomsUseCaseProvider = Provider<GetInitialRoomsUseCase>((ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return GetInitialRoomsUseCase(repo);
});

final savePropertyDraftUseCaseProvider = Provider<SavePropertyDraftUseCase>((ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return SavePropertyDraftUseCase(repo);
});

final propertyViewModelProvider = NotifierProvider<PropertyViewModel, PropertyState>(() {
  return PropertyViewModel();
});

class PropertyViewModel extends Notifier<PropertyState> {
  @override
  PropertyState build() {
    // initialize state and fetch initial rooms asynchronously
    _loadInitialData();
    return PropertyState(rooms: const [], outdoorExtras: const []);
  }

  Future<void> _loadInitialData() async {
    final rooms = await ref.read(getInitialRoomsUseCaseProvider).execute();
    // Load outdoor extras from datasource (currently none, placeholder for future extension)
    final outdoorExtras = await ref.read(propertyLocalDataSourceProvider).getInitialOutdoorExtras?.call() ?? [];
    state = state.copyWith(rooms: rooms, outdoorExtras: outdoorExtras);
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 6) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // Step 1 actions
  void selectPropertyType(PropertyType type) {
    state = state.copyWith(propertyType: type);
  }

  void selectPropertySubtype(PropertySubtype subtype) {
    state = state.copyWith(propertySubtype: subtype);
  }

  // Step 2 actions
  void updateAddress({
    String? streetAddress,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
  }) {
    state = state.copyWith(
      streetAddress: streetAddress ?? state.streetAddress,
      suburb: suburb ?? state.suburb,
      city: city ?? state.city,
      province: province ?? state.province,
      postalCode: postalCode ?? state.postalCode,
    );
  }

  void updateIdentifiers({String? complexName, String? erfPlotNumber}) {
    state = state.copyWith(
      complexName: complexName ?? state.complexName,
      erfPlotNumber: erfPlotNumber ?? state.erfPlotNumber,
    );
  }

  // Step 3 actions
  void updateTechnicalSpecs({
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
  }) {
    state = state.copyWith(
      erfSize: erfSize ?? state.erfSize,
      floorArea: floorArea ?? state.floorArea,
      constructionYear: constructionYear ?? state.constructionYear,
      maxHeight: maxHeight ?? state.maxHeight,
      zoning: zoning ?? state.zoning,
    );
  }

  void selectFacingDirection(FacingDirection direction) {
    state = state.copyWith(facingDirection: direction);
  }

  void selectArchitecturalStyle(ArchitecturalStyle style) {
    state = state.copyWith(architecturalStyle: style);
  }

  void selectRoofConfiguration(RoofConfiguration config) {
    state = state.copyWith(roofConfiguration: config);
  }

  void selectWallExterior(WallExterior wall) {
    state = state.copyWith(wallExterior: wall);
  }

  // Step 4.1 actions - Rooms
  void addCustomRoom(String name, RoomCategory category) {
    final newRoom = Room(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: category,
      description: 'Custom Space',
      isComplete: false,
    );
    state = state.copyWith(rooms: [...state.rooms, newRoom]);
  }

  // Outdoor items actions
  void toggleOutdoorExtra(String extra) {
    final current = List<String>.from(state.outdoorExtras);
    if (current.contains(extra)) {
      current.remove(extra);
    } else {
      current.add(extra);
    }
    state = state.copyWith(outdoorExtras: current);
  }

  void addCustomOutdoorExtra(String extra) {
    final current = List<String>.from(state.outdoorExtras);
    if (!current.contains(extra)) {
      current.add(extra);
      state = state.copyWith(outdoorExtras: current);
    }
  }

  // Step 4.2: Room-by-room detail actions
  void selectRoomForEditing(String? roomId) {
    if (roomId == null) {
      state = state.copyWith(clearRoomId: true);
    } else {
      state = state.copyWith(selectedRoomId: roomId);
    }
  }

  void updateRoomDetails({
    required String roomId,
    int? conditionRating,
    List<String>? features,
    String? notes,
  }) {
    final updatedRooms = state.rooms.map((room) {
      if (room.id == roomId) {
        return room.copyWith(
          conditionRating: conditionRating ?? room.conditionRating,
          features: features ?? room.features,
          notes: notes ?? room.notes,
          isComplete: conditionRating != null,
        );
      }
      return room;
    }).toList();

    state = state.copyWith(rooms: updatedRooms);
  }

  void renameRoom(String roomId, String newName) {
    final updatedRooms = state.rooms.map((room) {
      if (room.id == roomId) {
        return room.copyWith(name: newName);
      }
      return room;
    }).toList();

    state = state.copyWith(rooms: updatedRooms);
  }

  void addFeatureToRoom(String roomId, String feature) {
    final updatedRooms = state.rooms.map((room) {
      if (room.id == roomId) {
        final currentFeatures = List<String>.from(room.features);
        if (!currentFeatures.contains(feature)) {
          currentFeatures.add(feature);
        }
        return room.copyWith(features: currentFeatures);
      }
      return room;
    }).toList();

    state = state.copyWith(rooms: updatedRooms);
  }

  void removeFeatureFromRoom(String roomId, String feature) {
    final updatedRooms = state.rooms.map((room) {
      if (room.id == roomId) {
        final currentFeatures = List<String>.from(room.features);
        currentFeatures.remove(feature);
        return room.copyWith(features: currentFeatures);
      }
      return room;
    }).toList();

    state = state.copyWith(rooms: updatedRooms);
  }

  // Step 5 actions
  void selectMandateType(MandateType type) {
    state = state.copyWith(mandateType: type);
  }

  void selectLeadSource(LeadSource source) {
    state = state.copyWith(leadSource: source);
  }

  void toggleSyncLightstone(bool value) {
    state = state.copyWith(syncLightstone: value);
  }

  void toggleSyncLoom(bool value) {
    state = state.copyWith(syncLoom: value);
  }

  void updateOwnerInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? idNumber,
  }) {
    state = state.copyWith(
      ownerFirstName: firstName ?? state.ownerFirstName,
      ownerLastName: lastName ?? state.ownerLastName,
      ownerEmail: email ?? state.ownerEmail,
      ownerPhone: phone ?? state.ownerPhone,
      ownerIdNumber: idNumber ?? state.ownerIdNumber,
    );
  }

  void updateMandateDates({String? start, String? end}) {
    state = state.copyWith(
      mandateStart: start ?? state.mandateStart,
      mandateEnd: end ?? state.mandateEnd,
    );
  }

  Future<void> saveDraft() async {
    await ref.read(savePropertyDraftUseCaseProvider).execute(state);
  }
}
