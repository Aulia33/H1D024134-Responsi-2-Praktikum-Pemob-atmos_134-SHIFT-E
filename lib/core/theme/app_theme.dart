import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Sky inspired
  static const Color primaryBlue = Color(0xFF0F4C81); // Deep Classic Blue
  static const Color skyBlue = Color(0xFF0288D1);     // Vivid Sky Blue
  static const Color lightSkyBlue = Color(0xFF4FC3F7);// Soft Atmosphere Blue
  static const Color cloudWhite = Color(0xFFF8FAFC);  // Pristine Cloud White
  static const Color cardSurface = Colors.white;
  static const Color darkSlate = Color(0xFF0F172A);   // Text Primary
  static const Color mutedSlate = Color(0xFF64748B);  // Text Secondary
  static const Color accentCyan = Color(0xFF00ACC1);
  static const Color accentAmber = Color(0xFFFFA000); // Sun
  static const Color accentRed = Color(0xFFE53935);   // Heart / Alert

  // Sky Gradients
  static const LinearGradient dayClearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0277BD),
      Color(0xFF0288D1),
      Color(0xFF81D4FA),
      Color(0xFFE1F5FE),
    ],
    stops: [0.0, 0.35, 0.75, 1.0],
  );

  static const LinearGradient nightClearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A192F),
      Color(0xFF102A4C),
      Color(0xFF1E3A8A),
      Color(0xFF3B82F6),
    ],
    stops: [0.0, 0.35, 0.75, 1.0],
  );

  static const LinearGradient rainyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF263238),
      Color(0xFF37474F),
      Color(0xFF455A64),
      Color(0xFF78909C),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF455A64),
      Color(0xFF607D8B),
      Color(0xFF90A4AE),
      Color(0xFFCFD8DC),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient cardGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FFFFFF),
      Color(0x1AFFFFFF),
    ],
  );

  // Material Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: skyBlue,
        brightness: Brightness.light,
        primary: skyBlue,
        surface: cloudWhite,
      ),
      scaffoldBackgroundColor: cloudWhite,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
