import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final theme = ref.read(themeConfigProvider);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final displayName = _displayNameController.text.trim();

    if (username.isEmpty || password.isEmpty || displayName.isEmpty) return;

    setState(() => _isLoading = true);

    await ref
        .read(authProvider.notifier)
        .register(username, password, displayName);

    if (mounted) {
      setState(() => _isLoading = false);
      final authState = ref.read(authProvider);
      if (authState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage!),
            backgroundColor: theme.primaryColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeConfigProvider);
    final textTheme = theme.toThemeData().textTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'K',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 48,
                        color: theme.textPrimary,
                      ),
                    ),
                    Text(
                      'W',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 48,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Create Account',
                  style: textTheme.titleLarge?.copyWith(
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextInput(
                  label: 'Display Name',
                  placeholder: 'Enter your display name',
                  controller: _displayNameController,
                  keyboardType: TextInputType.name,
                  style: InputStyle.cardBorder,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                CustomTextInput(
                  label: 'Username',
                  placeholder: 'Choose a username',
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  style: InputStyle.cardBorder,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                CustomTextInput(
                  label: 'Password',
                  placeholder: 'Create a password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: InputStyle.cardBorder,
                  theme: theme,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: theme.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 20,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    maxWidth: 32,
                    minHeight: 20,
                    maxHeight: 20,
                  ),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Create Account',
                        fullWidth: true,
                        onTap: _handleRegister,
                        theme: theme,
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go(AppRoutes.loginPath),
                  child: Text(
                    'Already have an account? Sign In',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
