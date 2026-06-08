import 'package:flutter/material.dart';

@Deprecated('Use ref.watch(themeProvider) instead. This extension cannot access Riverpod providers.')
extension ThemeContext on BuildContext {
  @Deprecated('Use ref.watch(themeProvider) instead')
  dynamic get realEstateTheme => null;

  @Deprecated('Use ref.watch(themeProvider).toThemeData().textTheme instead')
  TextTheme? get realEstateTextTheme => null;
}
