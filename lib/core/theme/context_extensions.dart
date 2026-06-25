import 'package:flutter/material.dart';

@Deprecated('Use ref.watch(themeConfigProvider) instead. This extension cannot access Riverpod providers.')
extension ThemeContext on BuildContext {
  @Deprecated('Use ref.watch(themeConfigProvider) instead')
  dynamic get realEstateTheme => null;

  @Deprecated('Use ref.watch(themeConfigProvider).toThemeData().textTheme instead')
  TextTheme? get realEstateTextTheme => null;
}
