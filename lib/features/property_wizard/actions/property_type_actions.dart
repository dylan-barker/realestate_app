import '../data/models/enums/property_subtype.dart';
import '../data/models/enums/property_type.dart';
import '../data/models/property_state.dart';

extension PropertyTypeActions on PropertyState {
  PropertyState withPropertyType(PropertyType type) =>
      copyWith(propertyType: type);

  PropertyState withPropertySubtype(PropertySubtype subtype) =>
      copyWith(propertySubtype: subtype);
}
