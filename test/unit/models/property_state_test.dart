import 'package:flutter_test/flutter_test.dart';
import 'package:realestate_app/features/property_wizard/data/models/contact.dart';
import 'package:realestate_app/features/property_wizard/data/models/listing_parking.dart';
import 'package:realestate_app/features/property_wizard/data/models/listing_valuation.dart';
import 'package:realestate_app/features/property_wizard/data/models/property_running_costs.dart';
import 'package:realestate_app/features/property_wizard/data/models/property_state.dart';
import 'package:realestate_app/features/property_wizard/data/models/room.dart';

void main() {
  group('PropertyState', () {
    test('constructor sets default values', () {
      final state = PropertyState();

      expect(state.propertyTypeId, 1);
      expect(state.street, '');
      expect(state.suburb, '');
      expect(state.city, '');
      expect(state.rooms, isEmpty);
      expect(state.parking, isEmpty);
      expect(state.listingValuation, const ListingValuation());
      expect(state.propertyRunningCosts, const PropertyRunningCosts());
      expect(state.primaryContact, const Contact());
      expect(state.coContacts, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('copyWith() overrides specified fields', () {
      final state = PropertyState();

      final updated = state.copyWith(
        city: 'Johannesburg',
        street: 'Main St',
      );

      expect(updated.city, 'Johannesburg');
      expect(updated.street, 'Main St');
      expect(updated.propertyTypeId, 1);
    });

    test('copyWith() handles rooms list', () {
      final state = PropertyState();
      final rooms = [Room(id: '1', name: 'Bedroom', roomTypeId: 1)];

      final updated = state.copyWith(rooms: rooms);

      expect(updated.rooms.length, 1);
      expect(updated.rooms.first.name, 'Bedroom');
    });

    test('copyWith() handles parking list', () {
      final state = PropertyState();
      final parking = [const ListingParking(parkingTypeId: 1, quantity: 2)];

      final updated = state.copyWith(parking: parking);

      expect(updated.parking.length, 1);
      expect(updated.parking.first.quantity, 2);
    });

    test('copyWith() handles error message', () {
      final state = PropertyState();

      final updated = state.copyWith(errorMessage: 'Something went wrong');

      expect(updated.errorMessage, 'Something went wrong');
    });

    test('copyWith() handles valuation', () {
      final state = PropertyState();
      final valuation = const ListingValuation(ownersNetPrice: '2500000');

      final updated = state.copyWith(listingValuation: valuation);

      expect(updated.listingValuation.ownersNetPrice, '2500000');
    });

    test('copyWith() preserves fields not specified', () {
      final state = PropertyState(
        propertyTypeId: 3,
        street: 'Oak Ave',
      );

      final updated = state.copyWith(city: 'Durban');

      expect(updated.propertyTypeId, 3);
      expect(updated.street, 'Oak Ave');
      expect(updated.city, 'Durban');
    });
  });
}
