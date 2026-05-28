enum PropertySubtype {
  freeStanding,
  cluster,
  simplex,
  duplex,
  triplex,
  smallHolding,
}

extension PropertySubtypeExtension on PropertySubtype {
  String get displayString {
    switch (this) {
      case PropertySubtype.freeStanding:
        return 'Free Standing';
      case PropertySubtype.cluster:
        return 'Cluster';
      case PropertySubtype.simplex:
        return 'Simplex';
      case PropertySubtype.duplex:
        return 'Duplex';
      case PropertySubtype.triplex:
        return 'Triplex';
      case PropertySubtype.smallHolding:
        return 'Small Holding';
    }
  }

  static PropertySubtype fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'cluster':
        return PropertySubtype.cluster;
      case 'simplex':
        return PropertySubtype.simplex;
      case 'duplex':
        return PropertySubtype.duplex;
      case 'triplex':
        return PropertySubtype.triplex;
      case 'small holding':
      case 'smallholding':
        return PropertySubtype.smallHolding;
      case 'free standing':
      case 'freestanding':
      default:
        return PropertySubtype.freeStanding;
    }
  }
}
