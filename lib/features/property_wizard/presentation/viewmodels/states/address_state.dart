class AddressState {
  final String streetAddress;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;
  final String complexName;
  final String erfPlotNumber;

  AddressState({
    this.streetAddress = '124 Architecture Way',
    this.suburb = 'Westside Hills',
    this.city = 'San Francisco',
    this.province = 'California',
    this.postalCode = '94103',
    this.complexName = '',
    this.erfPlotNumber = '',
  });

  AddressState copyWith({
    String? streetAddress,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
    String? complexName,
    String? erfPlotNumber,
  }) {
    return AddressState(
      streetAddress: streetAddress ?? this.streetAddress,
      suburb: suburb ?? this.suburb,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      complexName: complexName ?? this.complexName,
      erfPlotNumber: erfPlotNumber ?? this.erfPlotNumber,
    );
  }
}
