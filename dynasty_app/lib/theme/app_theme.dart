import 'package:flutter/material.dart';

class AppTheme {
  // ─── NEW PREMIUM COLOR PALETTE ───
  // Backgrounds
  static const Color backgroundDark = Color(0xFF06080F);
  static const Color backgroundDeep = Color(0xFF0B0F1A);
  static const Color surfaceDark = Color(0xFF12172B);
  static const Color surfaceLight = Color(0xFF1A2040);
  static const Color cardDark = Color(0xFF151B33);

  // Primary gradient — Electric Violet to Hot Magenta
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);

  // Accents
  static const Color accentMagenta = Color(0xFFEC4899);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentEmerald = Color(0xFF34D399);
  static const Color accentRose = Color(0xFFFB7185);

  // Text
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color textSlate300 = Color(0xFFCBD5E1);
  static const Color textSlate400 = Color(0xFF94A3B8);
  static const Color textSlate500 = Color(0xFF64748B);
  static const Color textSlate600 = Color(0xFF475569);

  // Borders & Dividers
  static const Color borderDark = Color(0xFF1E293B);
  static const Color borderGlow = Color(0x338B5CF6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF151B33), Color(0xFF0F1225)],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accentCyan,
        surface: surfaceDark,
        error: accentRose,
        onPrimary: Colors.white,
        onSurface: textWhite,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textWhite,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: textSlate500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
