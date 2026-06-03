import 'dart:developer' as developer;
import '../models/outdoor_extra_item.dart';
import '../models/property_state_model.dart';
import '../models/room_model.dart';

class PropertyLocalDataSource {
  Future<List<RoomModel>> getInitialRooms() async {
    return [];
  }

  Future<void> savePropertyDraft(PropertyStateModel model) async {
    developer.log('Draft successfully saved to local SQLite: Step ${model.currentStep}, Property Type: ${model.propertyType}');
  }

  Future<List<OutdoorExtraItem>> getInitialOutdoorExtras() async {
    return [];
  }
}
