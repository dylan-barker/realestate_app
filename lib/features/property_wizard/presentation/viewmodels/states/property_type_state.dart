import '../../../domain/enums/property_subtype.dart';
import '../../../domain/enums/property_type.dart';

class PropertyTypeState {
  final PropertyType propertyType;
  final PropertySubtype propertySubtype;

  PropertyTypeState({
    this.propertyType = PropertyType.house,
    this.propertySubtype = PropertySubtype.freeStanding,
  });

  PropertyTypeState copyWith({
    PropertyType? propertyType,
    PropertySubtype? propertySubtype,
  }) {
    return PropertyTypeState(
      propertyType: propertyType ?? this.propertyType,
      propertySubtype: propertySubtype ?? this.propertySubtype,
    );
  }
}
