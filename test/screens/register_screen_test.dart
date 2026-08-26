import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:realestate_app/features/auth/presentation/screens/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renders all input fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: const RegisterScreen())),
    );

    expect(find.text('Display Name'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('RegisterScreen has create account button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: const RegisterScreen())),
    );

    expect(find.text('Create Account'), findsWidgets);
  });

  testWidgets('RegisterScreen has sign-in link', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: const RegisterScreen())),
    );

    expect(find.text('Already have an account? Sign In'), findsOneWidget);
  });
}
