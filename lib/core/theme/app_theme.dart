import 'package:flutter/material.dart';

class AppTheme {
  // Brand Palette from Design System
  static const Color primary = Color(0xFFFB7185);     // Coral Rose Pink #FB7185
  static const Color secondary = Color(0xFFFB923C);   // Sunset Orange #FB923C
  static const Color tertiary = Color(0xFFFBCFE8);    // Soft Pink #FBCFE8
  static const Color neutralBg = Color(0xFF180E1B);   // Midnight Dark Plum #180E1B

  // Card Surfaces & Borders
  static const Color cardSurface = Color(0xFF25172A);
  static const Color cardSurfaceElevated = Color(0xFF2F1D35);
  static const Color cardBorder = Color(0xFF3E2746);
  static const Color cardBorderLight = Color(0xFF563660);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE2D4E4);
  static const Color textMuted = Color(0xFFA18A9F);

  // Gradient accents
  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF381B38),
      Color(0xFF28142C),
      Color(0xFF200E24),
    ],
  );

  static const LinearGradient coralOrangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFB7185),
      Color(0xFFFB923C),
    ],
  );

  static const LinearGradient orangePinkBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFB923C),
      Color(0xFFFB7185),
    ],
  );

  static const LinearGradient activeTabGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFB7185),
      Color(0xFFFB923C),
    ],
  );

  // Material 3 Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: neutralBg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: cardSurface,
        onSurface: textPrimary,
      ),
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: cardBorder, width: 1.2),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
