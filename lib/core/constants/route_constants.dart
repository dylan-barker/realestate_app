/// Route paths shared between the router and screens.
abstract final class AppRoutes {
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String settingsPath = '/settings';

  static const String propertyPath = '/property/:id';
  static const String propertyTypePath = '/property/:id/property-type';
  static const String addressPath = '/property/:id/address';
  static const String buildingInfoPath = '/property/:id/building-info';
  static const String propertyFeaturesPath =
      '/property/:id/property-features';
  static const String roomDetailsPath = '/property/:id/room-details/:roomId';
  static const String valuationCostsPath = '/property/:id/valuation-costs';
  static const String contactsPath = '/property/:id/contacts';

  static String property(int id) => '/property/$id';
  static String propertyType(int id) => '/property/$id/property-type';
  static String address(int id) => '/property/$id/address';
  static String buildingInfo(int id) => '/property/$id/building-info';
  static String propertyFeatures(int id) => '/property/$id/property-features';
  static String roomDetails(int id, String roomId) =>
      '/property/$id/room-details/$roomId';
  static String valuationCosts(int id) => '/property/$id/valuation-costs';
  static String contacts(int id) => '/property/$id/contacts';
}
