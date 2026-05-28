import '../entities/property_state.dart';
import '../repositories/property_repository.dart';

class SavePropertyDraftUseCase {
  final IPropertyRepository _repository;

  SavePropertyDraftUseCase(this._repository);

  Future<void> execute(PropertyState propertyState) {
    return _repository.savePropertyDraft(propertyState);
  }
}
