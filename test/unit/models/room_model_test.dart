import 'package:flutter_test/flutter_test.dart';
import 'package:realestate_app/features/property_wizard/data/models/room.dart';
import 'package:realestate_app/features/property_wizard/data/models/room_model.dart';

void main() {
  group('RoomModel', () {
    test('fromEntity() converts Room to RoomModel', () {
      final room = Room(
        id: '1',
        name: 'Master Bedroom',
        roomTypeId: 1,
        conditionRating: 4,
        features: ['Aircon'],
        notes: 'Spacious',
      );

      final model = RoomModel.fromEntity(room);

      expect(model.id, '1');
      expect(model.name, 'Master Bedroom');
      expect(model.conditionRating, 4);
      expect(model.features, ['Aircon']);
      expect(model.notes, 'Spacious');
    });

    test('toEntity() converts RoomModel back to Room', () {
      final model = RoomModel(
        id: '1',
        name: 'Kitchen',
        roomTypeId: 3,
        createdAt: '2026-01-01T00:00:00.000',
        updatedAt: '2026-01-01T00:00:00.000',
      );

      final room = model.toEntity();

      expect(room.id, '1');
      expect(room.name, 'Kitchen');
      expect(room.roomTypeId, 3);
    });

    test('toMap() returns correct map', () {
      final model = RoomModel(
        id: '1',
        name: 'Bedroom',
        roomTypeId: 1,
        conditionRating: 3,
        features: ['Wardrobe'],
        notes: 'Needs painting',
        createdAt: '2026-01-01T00:00:00.000',
        updatedAt: '2026-01-01T00:00:00.000',
      );

      final map = model.toMap();

      expect(map['id'], '1');
      expect(map['name'], 'Bedroom');
      expect(map['conditionRating'], 3);
      expect(map['features'], ['Wardrobe']);
    });

    test('fromMap() restores RoomModel from map', () {
      final map = {
        'id': '2',
        'name': 'Living Room',
        'roomTypeId': 3,
        'features': ['TV Point'],
        'notes': '',
        'createdAt': '2026-06-01T00:00:00.000',
        'updatedAt': '2026-06-01T00:00:00.000',
      };

      final model = RoomModel.fromMap(map);

      expect(model.id, '2');
      expect(model.name, 'Living Room');
      expect(model.roomTypeId, 3);
      expect(model.features, ['TV Point']);
    });

    test('round-trip fromEntity -> toEntity preserves data', () {
      final room = Room(
        id: '5',
        name: 'Study',
        roomTypeId: 4,
        roomTypeOther: 'Home Office',
        conditionRating: 2,
        features: ['Desk', 'Bookshelf'],
        notes: 'Needs better lighting',
      );

      final model = RoomModel.fromEntity(room);
      final restored = model.toEntity();

      expect(restored.id, room.id);
      expect(restored.name, room.name);
      expect(restored.roomTypeId, room.roomTypeId);
      expect(restored.conditionRating, room.conditionRating);
      expect(restored.features, room.features);
      expect(restored.notes, room.notes);
    });
  });
}
