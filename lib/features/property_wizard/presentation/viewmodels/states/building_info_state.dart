import '../../../domain/enums/architectural_style.dart';
import '../../../domain/enums/facing_direction.dart';
import '../../../domain/enums/roof_configuration.dart';
import '../../../domain/enums/wall_exterior.dart';

class BuildingInfoState {
  final String erfSize;
  final String floorArea;
  final String constructionYear;
  final String maxHeight;
  final String zoning;
  final FacingDirection facingDirection;
  final ArchitecturalStyle architecturalStyle;
  final RoofConfiguration roofConfiguration;
  final WallExterior wallExterior;

  const BuildingInfoState({
    this.erfSize = '0.00',
    this.floorArea = '0.00',
    this.constructionYear = 'YYYY',
    this.maxHeight = '0.00',
    this.zoning = 'e.g. Residential 1',
    this.facingDirection = FacingDirection.north,
    this.architecturalStyle = ArchitecturalStyle.contemporary,
    this.roofConfiguration = RoofConfiguration.hipped,
    this.wallExterior = WallExterior.brick,
  });

  BuildingInfoState copyWith({
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
    FacingDirection? facingDirection,
    ArchitecturalStyle? architecturalStyle,
    RoofConfiguration? roofConfiguration,
    WallExterior? wallExterior,
  }) {
    return BuildingInfoState(
      erfSize: erfSize ?? this.erfSize,
      floorArea: floorArea ?? this.floorArea,
      constructionYear: constructionYear ?? this.constructionYear,
      maxHeight: maxHeight ?? this.maxHeight,
      zoning: zoning ?? this.zoning,
      facingDirection: facingDirection ?? this.facingDirection,
      architecturalStyle: architecturalStyle ?? this.architecturalStyle,
      roofConfiguration: roofConfiguration ?? this.roofConfiguration,
      wallExterior: wallExterior ?? this.wallExterior,
    );
  }
}
