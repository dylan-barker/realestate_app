enum RoofConfiguration {
  gabled,
  flat,
  hipped,
  mansard,
}

extension RoofConfigurationExtension on RoofConfiguration {
  String get displayString {
    switch (this) {
      case RoofConfiguration.gabled:
        return 'Gabled';
      case RoofConfiguration.flat:
        return 'Flat';
      case RoofConfiguration.hipped:
        return 'Hipped';
      case RoofConfiguration.mansard:
        return 'Mansard';
    }
  }

  static RoofConfiguration fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'gabled':
        return RoofConfiguration.gabled;
      case 'flat':
        return RoofConfiguration.flat;
      case 'mansard':
        return RoofConfiguration.mansard;
      case 'hipped':
      default:
        return RoofConfiguration.hipped;
    }
  }
}
