import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/themes.dart';
import 'features/property_wizard/presentation/views/property_wizard_shell.dart';

void main() {
  runApp(
    // Wrap entire app in ProviderScope for Riverpod state management
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dynamic theme setup
    final brandTheme = RealEstateTheme.crimson();

    return MaterialApp(
      title: 'Real Estate Data Capture Listing Tool',
      debugShowCheckedModeBanner: false,
      theme: brandTheme.toThemeData(),
      home: const PropertyWizardShell(),
    );
  }
}
