import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/property_overview/presentation/screens/address_screen.dart';
import '../../features/property_overview/presentation/screens/building_info_screen.dart';
import '../../features/property_overview/presentation/screens/contacts_screen.dart';
import '../../features/property_overview/presentation/screens/listing_valuation_screen.dart';
import '../../features/property_overview/presentation/screens/property_features_screen.dart';
import '../../features/property_overview/presentation/screens/property_overview_screen.dart';
import '../../features/property_overview/presentation/screens/property_type_screen.dart';
import '../../features/property_overview/presentation/screens/room_details_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isInitialized = authState.status != AuthStatus.uninitialized;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isInitialized) return null;

      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && isLoginRoute) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/property/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PropertyOverviewScreen(propertyId: id);
        },
      ),
      GoRoute(
        path: '/property/:id/property-type',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PropertyTypeScreen(),
      ),
      GoRoute(
        path: '/property/:id/address',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        path: '/property/:id/building-info',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BuildingInfoScreen(),
      ),
      GoRoute(
        path: '/property/:id/property-features',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PropertyFeaturesScreen(),
      ),
      GoRoute(
        path: '/property/:id/room-details/:roomId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return RoomDetailsScreen(roomId: roomId);
        },
      ),
      GoRoute(
        path: '/property/:id/valuation-costs',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ListingValuationScreen(),
      ),
      GoRoute(
        path: '/property/:id/contacts',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ContactsScreen(),
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
