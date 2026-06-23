import '../models/property_state.dart';
import '../models/room.dart';
import 'property_repository.dart';
import '../data_sources/property_local_data_source.dart';
import '../models/property_state_model.dart';

class PropertyRepositoryImpl implements IPropertyRepository {
  final PropertyLocalDataSource _localDataSource;

  PropertyRepositoryImpl(this._localDataSource);

  @override
  Future<List<Room>> getInitialRooms() async {
    final roomModels = await _localDataSource.getInitialRooms();
    return roomModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> savePropertyDraft(PropertyState propertyState) async {
    final stateModel = PropertyStateModel.fromEntity(propertyState);
    await _localDataSource.savePropertyDraft(stateModel);
  }
}
