import 'package:flutter/material.dart';

import 'themes.dart';

extension ThemeContext on BuildContext {
  RealEstateTheme get realEstateTheme => RealEstateTheme.crimson();

  TextTheme get realEstateTextTheme =>
      RealEstateTheme.crimson().toThemeData().textTheme;
}
