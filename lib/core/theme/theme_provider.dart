import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'themes.dart';

final themeProvider = Provider<RealEstateTheme>((ref) {
  return RealEstateTheme.crimson();
});
