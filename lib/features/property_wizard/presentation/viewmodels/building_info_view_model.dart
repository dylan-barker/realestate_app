import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/facing_direction.dart';
import '../../domain/enums/architectural_style.dart';
import '../../domain/enums/roof_configuration.dart';
import '../../domain/enums/wall_exterior.dart';
import 'states/building_info_state.dart';

final buildingInfoViewModelProvider = NotifierProvider<BuildingInfoViewModel, BuildingInfoState>(
  () => BuildingInfoViewModel(),
);

class BuildingInfoViewModel extends Notifier<BuildingInfoState> {
  @override
  BuildingInfoState build() => const BuildingInfoState();

  void updateTechnicalSpecs({
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
  }) {
    state = state.copyWith(
      erfSize: erfSize ?? state.erfSize,
      floorArea: floorArea ?? state.floorArea,
      constructionYear: constructionYear ?? state.constructionYear,
      maxHeight: maxHeight ?? state.maxHeight,
      zoning: zoning ?? state.zoning,
    );
  }

  void selectFacingDirection(FacingDirection direction) {
    state = state.copyWith(facingDirection: direction);
  }

  void selectArchitecturalStyle(ArchitecturalStyle style) {
    state = state.copyWith(architecturalStyle: style);
  }

  void selectRoofConfiguration(RoofConfiguration config) {
    state = state.copyWith(roofConfiguration: config);
  }

  void selectWallExterior(WallExterior wall) {
    state = state.copyWith(wallExterior: wall);
  }
}
