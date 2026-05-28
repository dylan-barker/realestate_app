import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/themes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brandTheme = RealEstateTheme.crimson();

    return MaterialApp.router(
      title: 'Real Estate Data Capture',
      debugShowCheckedModeBanner: false,
      theme: brandTheme.toThemeData(),
      routerConfig: appRouter,
    );
  }
}
