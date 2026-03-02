import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0F0C29);
  static const Color primary = Color(0xFF6F00FF);
  static const Color secondary = Color(0xFF00D2FF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color backgroundDark = Color(0xFF1A103C);

  static ThemeData get dreamyTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      useMaterial3: true,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textSecondary,
          fontSize: 18,
          height: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
