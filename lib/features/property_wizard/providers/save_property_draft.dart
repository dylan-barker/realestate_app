import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/property_state.dart';
import 'property_provider.dart';

final savePropertyDraftProvider = FutureProvider.family<void, PropertyState>((
  ref,
  state,
) async {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.savePropertyDraft(state);
});
