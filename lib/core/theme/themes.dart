import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Represents the styling configuration for a real estate brand.
class RealEstateTheme {
  final String brandName;
  final Color primaryColor; // e.g., Crimson (#CC0000) for KW
  final Color secondaryColor; // e.g., Slate/Stone
  final Color backgroundColor; // Light gray/cream editorial background
  final Color cardBackgroundColor; // Clean white cards
  final Color textPrimary; // High contrast charcoal/black
  final Color textSecondary; // Subtle zinc/grey
  final Color textLabel; // Warm brown for labels
  
  final Color completeColor; // Semantic green for completed rooms
  final Color pendingColor; // Semantic orange for pending items
  
  final Color borderLight;
  final Color borderSelected;
  
  RealEstateTheme({
    required this.brandName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.cardBackgroundColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLabel,
    required this.completeColor,
    required this.pendingColor,
    required this.borderLight,
    required this.borderSelected,
  });

  /// Factory for the default "Editorial Crimson" (inspired by KW)
  factory RealEstateTheme.crimson() {
    return RealEstateTheme(
      brandName: 'Editorial Crimson',
      primaryColor: const Color(0xFFCC0000),
      secondaryColor: const Color(0xFF1E1E1E),
      backgroundColor: const Color(0xFFFAF9F6), // Sophisticated editorial off-white
      cardBackgroundColor: Colors.white,
      textPrimary: const Color(0xFF111111),
      textSecondary: const Color(0xFF71717A),
      textLabel: const Color(0xFF5C4033), // Elegant brown label style
      completeColor: const Color(0xFF0F9D58), // Emerald green
      pendingColor: const Color(0xFFD97706), // Amber/orange
      borderLight: const Color(0xFFE4E4E7),
      borderSelected: const Color(0xFFCC0000),
    );
  }

  /// Factory for a modern "Editorial Slate" brand
  factory RealEstateTheme.slate() {
    return RealEstateTheme(
      brandName: 'Editorial Slate',
      primaryColor: const Color(0xFF2D3748), // Cool slate
      secondaryColor: const Color(0xFF1A202C),
      backgroundColor: const Color(0xFFF7FAFC),
      cardBackgroundColor: Colors.white,
      textPrimary: const Color(0xFF1A202C),
      textSecondary: const Color(0xFF718096),
      textLabel: const Color(0xFF4A5568),
      completeColor: const Color(0xFF319795),
      pendingColor: const Color(0xFFDD6B20),
      borderLight: const Color(0xFFE2E8F0),
      borderSelected: const Color(0xFF2D3748),
    );
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardBackgroundColor,
      ),
      textTheme: TextTheme(
        // Modern typography using Google Fonts Inter with tight tracking
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textLabel,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),
    );
  }
}
