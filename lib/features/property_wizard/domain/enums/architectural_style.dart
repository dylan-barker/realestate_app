enum ArchitecturalStyle {
  modern,
  contemporary,
  traditional,
}

extension ArchitecturalStyleExtension on ArchitecturalStyle {
  String get displayString {
    switch (this) {
      case ArchitecturalStyle.modern:
        return 'Modern';
      case ArchitecturalStyle.contemporary:
        return 'Contemporary';
      case ArchitecturalStyle.traditional:
        return 'Traditional';
    }
  }

  static ArchitecturalStyle fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'modern':
        return ArchitecturalStyle.modern;
      case 'traditional':
        return ArchitecturalStyle.traditional;
      case 'contemporary':
      default:
        return ArchitecturalStyle.contemporary;
    }
  }
}
