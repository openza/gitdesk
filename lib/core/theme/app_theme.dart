import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color _primaryColor = Color(0xFF58A6FF);
  static const Color _backgroundColor = Color(0xFF0D1117);
  static const Color _surfaceColor = Color(0xFF161B22);
  static const Color _cardColor = Color(0xFF21262D);
  static const Color _borderColor = Color(0xFF30363D);
  static const Color _textPrimary = Color(0xFFE6EDF3);
  static const Color _textSecondary = Color(0xFF8B949E);
  static const Color _textMuted = Color(0xFF6E7681);
  static const Color _successColor = Color(0xFF3FB950);
  static const Color _warningColor = Color(0xFFD29922);
  static const Color _errorColor = Color(0xFFF85149);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: _backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        surface: _surfaceColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSurface: _textPrimary,
        onError: Colors.white,
        outline: _borderColor,
      ),
      cardTheme: CardThemeData(
        color: _cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: _borderColor, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceColor,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: _textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: _textPrimary,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(
          color: _textSecondary,
          fontSize: 13,
        ),
        bodySmall: TextStyle(
          color: _textMuted,
          fontSize: 12,
        ),
        labelMedium: TextStyle(
          color: _textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _errorColor),
        ),
        hintStyle: const TextStyle(color: _textMuted),
        labelStyle: const TextStyle(color: _textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(color: _borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
        ),
      ),
      iconTheme: const IconThemeData(
        color: _textSecondary,
        size: 20,
      ),
      dividerTheme: const DividerThemeData(
        color: _borderColor,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceColor,
        labelStyle: const TextStyle(
          color: _textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: _borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _cardColor,
        contentTextStyle: const TextStyle(color: _textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Semantic colors for use in widgets
  static const Color success = _successColor;
  static const Color warning = _warningColor;
  static const Color error = _errorColor;
  static const Color primary = _primaryColor;
  static const Color surface = _surfaceColor;
  static const Color card = _cardColor;
  static const Color border = _borderColor;
  static const Color textPrimary = _textPrimary;
  static const Color textSecondary = _textSecondary;
  static const Color textMuted = _textMuted;
}
