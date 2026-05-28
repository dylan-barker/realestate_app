enum WallExterior {
  brick,
  stucco,
  stone,
  wood,
}

extension WallExteriorExtension on WallExterior {
  String get displayString {
    switch (this) {
      case WallExterior.brick:
        return 'Brick';
      case WallExterior.stucco:
        return 'Stucco';
      case WallExterior.stone:
        return 'Stone';
      case WallExterior.wood:
        return 'Wood';
    }
  }

  static WallExterior fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'stucco':
        return WallExterior.stucco;
      case 'stone':
        return WallExterior.stone;
      case 'wood':
        return WallExterior.wood;
      case 'brick':
      default:
        return WallExterior.brick;
    }
  }
}
