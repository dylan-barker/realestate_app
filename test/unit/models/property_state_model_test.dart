import 'package:flutter_test/flutter_test.dart';
import 'package:realestate_app/features/property_wizard/data/models/contact.dart';
import 'package:realestate_app/features/property_wizard/data/models/listing_valuation.dart';
import 'package:realestate_app/features/property_wizard/data/models/property_running_costs.dart';
import 'package:realestate_app/features/property_wizard/data/models/property_state.dart';
import 'package:realestate_app/features/property_wizard/data/models/property_state_model.dart';
import 'package:realestate_app/features/property_wizard/data/models/room.dart';

void main() {
  group('PropertyStateModel', () {
    test('fromEntity() converts PropertyState to PropertyStateModel', () {
      final state = PropertyState(
        currentStep: 3,
        propertyTypeId: 2,
        street: 'Main St',
        city: 'Cape Town',
        rooms: [Room(id: '1', name: 'Bedroom', roomTypeId: 1)],
        errorMessage: null,
      );

      final model = PropertyStateModel.fromEntity(state);

      expect(model.currentStep, 3);
      expect(model.propertyTypeId, 2);
      expect(model.street, 'Main St');
      expect(model.city, 'Cape Town');
      expect(model.rooms.length, 1);
      expect(model.errorMessage, isNull);
    });

    test('toEntity() converts PropertyStateModel back to PropertyState', () {
      final model = PropertyStateModel(
        currentStep: 5,
        selectedRoomId: null,
        propertyTypeId: 1,
        streetNumber: '',
        street: 'Oak Ave',
        unitNumber: '',
        suburb: 'Suburb',
        city: 'Durban',
        province: 'KZN',
        country: 'South Africa',
        postalCode: '4001',
        estateName: '',
        erfNumber: '',
        latitude: null,
        longitude: null,
        erfSize: '',
        floorArea: '',
        constructionYear: '',
        facingId: null,
        zoningId: null,
        rooms: [],
        parking: [],
        outdoorFeatures: [],
        listingValuation: {
          'ownersNetPrice': '',
          'agentValuation': '',
          'commissionPercent': '',
        },
        propertyRunningCosts: {
          'monthlyLevy': '',
          'monthlyRates': '',
          'electricity': '',
          'water': '',
        },
        primaryContact: {
          'id': '',
          'fullName': '',
          'idNumber': '',
          'companyName': '',
          'companyRegistrationNumber': '',
          'mobilePhone': '',
          'emailAddress': '',
          'role': '',
        },
        coContacts: [],
        listingId: null,
        referenceNumber: '',
        status: 'draft',
        p24Ref: null,
        errorMessage: null,
      );

      final state = model.toEntity();

      expect(state.currentStep, 5);
      expect(state.street, 'Oak Ave');
      expect(state.city, 'Durban');
      expect(state.rooms, isEmpty);
    });

    test('round-trip fromEntity -> toEntity preserves data', () {
      final original = PropertyState(
        currentStep: 4,
        propertyTypeId: 3,
        street: '123 Main',
        city: 'Johannesburg',
        rooms: [Room(id: '1', name: 'Bedroom', roomTypeId: 1)],
        listingValuation: ListingValuation(ownersNetPrice: '3000000'),
        propertyRunningCosts: PropertyRunningCosts(monthlyLevy: '2000'),
        primaryContact: Contact(
          fullName: 'John',
          emailAddress: 'john@test.com',
        ),
      );

      final model = PropertyStateModel.fromEntity(original);
      final restored = model.toEntity();

      expect(restored.currentStep, original.currentStep);
      expect(restored.propertyTypeId, original.propertyTypeId);
      expect(restored.street, original.street);
      expect(restored.city, original.city);
      expect(restored.rooms.length, original.rooms.length);
      expect(
        restored.listingValuation.ownersNetPrice,
        original.listingValuation.ownersNetPrice,
      );
      expect(
        restored.propertyRunningCosts.monthlyLevy,
        original.propertyRunningCosts.monthlyLevy,
      );
      expect(
        restored.primaryContact.fullName,
        original.primaryContact.fullName,
      );
      expect(
        restored.primaryContact.emailAddress,
        original.primaryContact.emailAddress,
      );
    });
  });
}
