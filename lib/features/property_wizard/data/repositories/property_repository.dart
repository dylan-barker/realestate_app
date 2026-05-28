import '../models/property_state.dart';
import '../models/room.dart';

abstract class IPropertyRepository {
  Future<List<Room>> getInitialRooms();
  Future<void> savePropertyDraft(PropertyState propertyState);
  Future<List<String>> getInitialOutdoorExtras();
}
