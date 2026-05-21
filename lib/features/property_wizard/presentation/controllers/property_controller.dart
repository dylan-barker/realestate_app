import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/room_model.dart';
import '../../data/models/property_state_model.dart';

class PropertyController extends Notifier<PropertyStateModel> {
  @override
  PropertyStateModel build() {
    // Populate standard high-fidelity rooms corresponding to the screenshot!
    final initialRooms = [
      RoomModel(
        id: 'bed-1',
        name: 'Bedroom 1',
        type: 'Bedrooms',
        description: 'Master Suite',
        isComplete: true,
        conditionRating: 3,
        features: [
          'Ceiling Fan',
          'Wall-to-Wall Carpets',
          'Air Conditioning',
          'Built-in Cupboards',
          'En-suite Bathroom',
          'Balcony'
        ],
        notes: 'Spacious master suite with premium dynamic views.',
      ),
      RoomModel(
        id: 'bed-2',
        name: 'Bedroom 2',
        type: 'Bedrooms',
        description: 'Standard',
        isComplete: false,
      ),
      RoomModel(
        id: 'bed-3',
        name: 'Bedroom 3',
        type: 'Bedrooms',
        description: 'Guest Room',
        isComplete: false,
      ),
      RoomModel(
        id: 'bed-4',
        name: 'Bedroom 4',
        type: 'Bedrooms',
        description: 'Children\'s Room',
        isComplete: false,
      ),
      RoomModel(
        id: 'live-1',
        name: 'Main Living Area',
        type: 'Living & Dining',
        description: 'Open Plan',
        isComplete: true,
        conditionRating: 4,
        features: ['Air Conditioning', 'Built-in Cupboards'],
        notes: 'Beautiful double-volume ceiling living room.',
      ),
      RoomModel(
        id: 'live-2',
        name: 'Gourmet Kitchen',
        type: 'Living & Dining',
        description: 'Primary kitchen',
        isComplete: false,
      ),
      RoomModel(
        id: 'bath-1',
        name: 'Full Bathroom 1',
        type: 'Bathrooms & Powder',
        description: 'En-suite',
        isComplete: false,
      ),
      RoomModel(
        id: 'bath-2',
        name: 'Full Bathroom 2',
        type: 'Bathrooms & Powder',
        description: 'Shared Bath',
        isComplete: false,
      ),
      RoomModel(
        id: 'bath-3',
        name: 'Powder Room',
        type: 'Bathrooms & Powder',
        description: 'Guest WC',
        isComplete: false,
      ),
    ];

    return PropertyStateModel(
      currentStep: 1,
      rooms: initialRooms,
    );
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
  void selectPropertyType(String type) {
    state = state.copyWith(propertyType: type);
  }

  void selectPropertySubtype(String subtype) {
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

  void selectFacingDirection(String direction) {
    state = state.copyWith(facingDirection: direction);
  }

  void selectArchitecturalStyle(String style) {
    state = state.copyWith(architecturalStyle: style);
  }

  void selectRoofConfiguration(String config) {
    state = state.copyWith(roofConfiguration: config);
  }

  void selectWallExterior(String wall) {
    state = state.copyWith(wallExterior: wall);
  }

  // Step 4.1 actions - Rooms
  void addCustomRoom(String name, String type) {
    final newRoom = RoomModel(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: type,
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
    state = state.copyWith(selectedRoomId: roomId);
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
          // Mark room as complete if condition rating is assigned
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
}

// Global Provider
final propertyControllerProvider =
    NotifierProvider<PropertyController, PropertyStateModel>(() {
  return PropertyController();
});
