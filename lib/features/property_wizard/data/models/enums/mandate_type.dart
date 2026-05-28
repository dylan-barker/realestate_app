enum MandateType {
  exclusive,
  open,
}

extension MandateTypeExtension on MandateType {
  String get displayString {
    switch (this) {
      case MandateType.exclusive:
        return 'Exclusive';
      case MandateType.open:
        return 'Open';
    }
  }

  static MandateType fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'open':
        return MandateType.open;
      case 'exclusive':
      default:
        return MandateType.exclusive;
    }
  }
}
