import 'dart:developer' as developer;
import '../models/property_state_model.dart';
import '../models/room_model.dart';

class PropertyLocalDataSource {
  Future<List<RoomModel>> getInitialRooms() async {
    return [];
  }

  Future<void> savePropertyDraft(PropertyStateModel model) async {
    developer.log('Draft saved: Step ${model.currentStep}, Property Type ID: ${model.propertyTypeId}');
  }
}
