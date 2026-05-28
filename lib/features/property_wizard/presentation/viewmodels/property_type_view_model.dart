import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/property_subtype.dart';
import '../../domain/enums/property_type.dart';
import 'states/property_type_state.dart';

final propertyTypeViewModelProvider = NotifierProvider<PropertyTypeViewModel, PropertyTypeState>(() {
  return PropertyTypeViewModel();
});

class PropertyTypeViewModel extends Notifier<PropertyTypeState> {
  @override
  PropertyTypeState build() {
    return PropertyTypeState();
  }

  void selectPropertyType(PropertyType type) {
    state = state.copyWith(propertyType: type);
  }

  void selectPropertySubtype(PropertySubtype subtype) {
    state = state.copyWith(propertySubtype: subtype);
  }
}
