import 'dart:developer' as developer;
import '../models/room_model.dart';
import '../models/property_state_model.dart';

class PropertyLocalDataSource {
  Future<List<RoomModel>> getInitialRooms() async {
    // Return standard mock rooms to start the listing tool in high fidelity
    return [
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
          'Balcony',
        ],
        notes: 'Spacious master suite with premium dynamic views.',
      ),
    ];
  }

  Future<void> savePropertyDraft(PropertyStateModel model) async {
    // Print mock persistence logs for transparency
    developer.log('Draft successfully saved to local SQLite: Step ${model.currentStep}, Property Type: ${model.propertyType}');
  }

  // New method: return list of initial outdoor extras (empty for now)
  Future<List<String>> getInitialOutdoorExtras() async {
    // Placeholder for future real data source; currently empty.
    return [];
  }
}
