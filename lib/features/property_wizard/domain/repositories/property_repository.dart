import '../entities/property_state.dart';
import '../entities/room.dart';

abstract class IPropertyRepository {
  Future<List<Room>> getInitialRooms();
  Future<void> savePropertyDraft(PropertyState propertyState);
}
