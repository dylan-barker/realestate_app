import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/address_state.dart';

final addressViewModelProvider = NotifierProvider<AddressViewModel, AddressState>(() {
  return AddressViewModel();
});

class AddressViewModel extends Notifier<AddressState> {
  @override
  AddressState build() {
    return AddressState();
  }

  void updateAddress({
    String? streetAddress,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
  }) {
    state = state.copyWith(
      streetAddress: streetAddress ?? state.streetAddress,
      suburb: suburb ?? state.suburb,
      city: city ?? state.city,
      province: province ?? state.province,
      postalCode: postalCode ?? state.postalCode,
    );
  }

  void updateIdentifiers({String? complexName, String? erfPlotNumber}) {
    state = state.copyWith(
      complexName: complexName ?? state.complexName,
      erfPlotNumber: erfPlotNumber ?? state.erfPlotNumber,
    );
  }
}
