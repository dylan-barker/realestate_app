import '../entities/room.dart';
import '../repositories/property_repository.dart';

class GetInitialRoomsUseCase {
  final IPropertyRepository _repository;

  GetInitialRoomsUseCase(this._repository);

  Future<List<Room>> execute() {
    return _repository.getInitialRooms();
  }
}
