import '../data/models/enums/architectural_style.dart';
import '../data/models/enums/facing_direction.dart';
import '../data/models/enums/roof_configuration.dart';
import '../data/models/enums/wall_exterior.dart';
import '../data/models/property_state.dart';

extension BuildingInfoActions on PropertyState {
  PropertyState withTechnicalSpecs({
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
  }) {
    return copyWith(
      erfSize: erfSize ?? this.erfSize,
      floorArea: floorArea ?? this.floorArea,
      constructionYear: constructionYear ?? this.constructionYear,
      maxHeight: maxHeight ?? this.maxHeight,
      zoning: zoning ?? this.zoning,
    );
  }

  PropertyState withFacingDirection(FacingDirection direction) =>
      copyWith(facingDirection: direction);

  PropertyState withArchitecturalStyle(ArchitecturalStyle style) =>
      copyWith(architecturalStyle: style);

  PropertyState withRoofConfig(RoofConfiguration config) =>
      copyWith(roofConfiguration: config);

  PropertyState withWallExterior(WallExterior wall) =>
      copyWith(wallExterior: wall);
}
