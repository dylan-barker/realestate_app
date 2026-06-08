import '../data/models/property_state.dart';

extension AddressActions on PropertyState {
  PropertyState withAddress({
    String? streetAddress,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
  }) {
    return copyWith(
      streetAddress: streetAddress ?? this.streetAddress,
      suburb: suburb ?? this.suburb,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  PropertyState withIdentifiers({
    String? complexName,
    String? erfPlotNumber,
  }) {
    return copyWith(
      complexName: complexName ?? this.complexName,
      erfPlotNumber: erfPlotNumber ?? this.erfPlotNumber,
    );
  }
}
