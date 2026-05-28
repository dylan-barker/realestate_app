import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/enums/facing_direction.dart';
import '../../data/models/enums/architectural_style.dart';
import '../../data/models/enums/roof_configuration.dart';
import '../../data/models/enums/wall_exterior.dart';
import 'states/building_info_state.dart';
import 'property_provider.dart';

final buildingInfoViewModelProvider = NotifierProvider<BuildingInfoViewModel, BuildingInfoState>(
  () => BuildingInfoViewModel(),
);

class BuildingInfoViewModel extends Notifier<BuildingInfoState> {
  @override
  BuildingInfoState build() {
    final mainState = ref.watch(propertyViewModelProvider);
    return BuildingInfoState(
      erfSize: mainState.erfSize,
      floorArea: mainState.floorArea,
      constructionYear: mainState.constructionYear,
      maxHeight: mainState.maxHeight,
      zoning: mainState.zoning,
      facingDirection: mainState.facingDirection,
      architecturalStyle: mainState.architecturalStyle,
      roofConfiguration: mainState.roofConfiguration,
      wallExterior: mainState.wallExterior,
    );
  }

  void updateTechnicalSpecs({
    String? erfSize,
    String? floorArea,
    String? constructionYear,
    String? maxHeight,
    String? zoning,
  }) {
    ref.read(propertyViewModelProvider.notifier).updateTechnicalSpecs(
      erfSize: erfSize,
      floorArea: floorArea,
      constructionYear: constructionYear,
      maxHeight: maxHeight,
      zoning: zoning,
    );
  }

  void selectFacingDirection(FacingDirection direction) {
    ref.read(propertyViewModelProvider.notifier).selectFacingDirection(direction);
  }

  void selectArchitecturalStyle(ArchitecturalStyle style) {
    ref.read(propertyViewModelProvider.notifier).selectArchitecturalStyle(style);
  }

  void selectRoofConfiguration(RoofConfiguration config) {
    ref.read(propertyViewModelProvider.notifier).selectRoofConfiguration(config);
  }

  void selectWallExterior(WallExterior wall) {
    ref.read(propertyViewModelProvider.notifier).selectWallExterior(wall);
  }
}
