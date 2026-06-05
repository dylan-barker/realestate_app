import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_sources/property_local_data_source.dart';
import '../data/models/enums/architectural_style.dart';
import '../data/models/enums/facing_direction.dart';
import '../data/models/enums/lead_source.dart';
import '../data/models/enums/mandate_type.dart';
import '../data/models/enums/property_subtype.dart';
import '../data/models/enums/property_type.dart';
import '../data/models/enums/property_wizard_step.dart';
import '../data/models/enums/roof_configuration.dart';
import '../data/models/enums/outdoor_extra.dart';
import '../data/models/enums/room_category.dart';
import '../data/models/enums/wall_exterior.dart';
import '../data/models/outdoor_extra_item.dart';
import '../data/models/property_state.dart';
import '../data/models/room.dart';
import '../data/repositories/property_repository.dart';
import '../data/repositories/property_repository_impl.dart';


final propertyLocalDataSourceProvider = Provider<PropertyLocalDataSource>((
  ref,
) {
  return PropertyLocalDataSource();
});

final propertyRepositoryProvider = Provider<IPropertyRepository>((ref) {
  final dataSource = ref.watch(propertyLocalDataSourceProvider);
  return PropertyRepositoryImpl(dataSource);
});

final propertyViewModelProvider =
    NotifierProvider<PropertyViewModel, PropertyState>(() {
      return PropertyViewModel();
    });

class PropertyViewModel extends Notifier<PropertyState> {
  @override
  PropertyState build() {
    _loadInitialData();
    return PropertyState(rooms: const [], outdoorExtras: const []);
  }

  Future<void> _loadInitialData() async {
    try {
      final repository = ref.read(propertyRepositoryProvider);
      final rooms = await repository.getInitialRooms();
      final outdoorExtras = await repository.getInitialOutdoorExtras();
      state = state.copyWith(rooms: rooms, outdoorExtras: outdoorExtras);
    } catch (e) {
      state = state.copyWith(rooms: const [], outdoorExtras: const []);
    }
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < PropertyWizardStep.values.length) {
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

  void removeRoom(String roomId) {
    final updatedRooms = state.rooms.where((r) => r.id != roomId).toList();
    state = state.copyWith(rooms: updatedRooms);
  }

  // Outdoor items actions
  void addOutdoorExtra(String name, {OutdoorExtraCategory? category}) {
    final current = List<OutdoorExtraItem>.from(state.outdoorExtras);
    final existingIdx = current.indexWhere((item) => item.name == name);
    if (existingIdx >= 0) {
      current[existingIdx] = current[existingIdx].copyWith(
        quantity: current[existingIdx].quantity + 1,
      );
    } else {
      current.add(OutdoorExtraItem(name: name, category: category));
    }
    state = state.copyWith(outdoorExtras: current);
  }

  void removeOutdoorExtra(String name) {
    final current = List<OutdoorExtraItem>.from(state.outdoorExtras);
    current.removeWhere((item) => item.name == name);
    state = state.copyWith(outdoorExtras: current);
  }

  void incrementOutdoorQuantity(String name) {
    final current = List<OutdoorExtraItem>.from(state.outdoorExtras);
    final idx = current.indexWhere((item) => item.name == name);
    if (idx >= 0) {
      current[idx] = current[idx].copyWith(quantity: current[idx].quantity + 1);
      state = state.copyWith(outdoorExtras: current);
    }
  }

  void decrementOutdoorQuantity(String name) {
    final current = List<OutdoorExtraItem>.from(state.outdoorExtras);
    final idx = current.indexWhere((item) => item.name == name);
    if (idx >= 0) {
      if (current[idx].quantity <= 1) {
        current.removeAt(idx);
      } else {
        current[idx] = current[idx].copyWith(
          quantity: current[idx].quantity - 1,
        );
      }
      state = state.copyWith(outdoorExtras: current);
    }
  }

  // Step 4.2: Room-by-room detail actions
  void selectRoomForEditing(String? roomId) {
    state = state.copyWith(selectedRoomId: roomId);
  }

  void updateRoomDetails({
    required String roomId,
    int? conditionRating,
    List<String>? features,
    String? notes,
    String? imagePath,
  }) {
    final updatedRooms = state.rooms.map((room) {
      if (room.id == roomId) {
        return room.copyWith(
          conditionRating: conditionRating ?? room.conditionRating,
          features: features ?? room.features,
          notes: notes ?? room.notes,
          imagePath: imagePath ?? room.imagePath,
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
    final repository = ref.read(propertyRepositoryProvider);
    await repository.savePropertyDraft(state);
  }
}
