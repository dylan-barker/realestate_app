import 'package:go_router/go_router.dart';

import '../../features/property_wizard/presentation/screens/property_type_screen.dart';
import '../../features/property_wizard/presentation/screens/address_screen.dart';
import '../../features/property_wizard/presentation/screens/building_info_screen.dart';
import '../../features/property_wizard/presentation/screens/property_features_screen.dart';
import '../../features/property_wizard/presentation/screens/room_details_screen.dart';
import '../../features/property_wizard/presentation/screens/listing_valuation_screen.dart';
import '../../features/property_wizard/presentation/screens/contacts_screen.dart';
import '../../features/property_wizard/presentation/screens/review_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/wizard/property-type',
  routes: [
    GoRoute(
      path: '/wizard/property-type',
      builder: (context, state) => const PropertyTypeStep(),
    ),
    GoRoute(
      path: '/wizard/address',
      builder: (context, state) => const AddressStep(),
    ),
    GoRoute(
      path: '/wizard/building-info',
      builder: (context, state) => const BuildingInfoStep(),
    ),
    GoRoute(
      path: '/wizard/property-features',
      builder: (context, state) => const PropertyFeaturesStep(),
    ),
    GoRoute(
      path: '/wizard/room-details/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return RoomDetailsStep(roomId: roomId);
      },
    ),
    GoRoute(
      path: '/wizard/valuation-costs',
      builder: (context, state) => const ValuationCostsStep(),
    ),
    GoRoute(
      path: '/wizard/contacts',
      builder: (context, state) => const ContactsStep(),
    ),
    GoRoute(
      path: '/wizard/review',
      builder: (context, state) => const ReviewStep(),
    ),
  ],
);
