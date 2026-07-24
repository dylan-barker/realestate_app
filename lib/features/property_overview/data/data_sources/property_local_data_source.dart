import 'dart:developer' as developer;

import '../models/property_state.dart';

class PropertyLocalDataSource {
  Future<void> savePropertyDraft(PropertyState state) async {
    developer.log('Draft saved: Property Type ID: ${state.propertyTypeId}');
  }
}
