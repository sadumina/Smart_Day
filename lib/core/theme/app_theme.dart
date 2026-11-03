import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const navy = Color(0xFF0F172A);
  static const slate = Color(0xFF64748B);
  static const indigo = Color(0xFF4F46E5);

  static ThemeData light() => _buildTheme(
        brightness: Brightness.light,
        background: const Color(0xFFF8FAFC),
        surface: Colors.white,
      );

  static ThemeData dark() => _buildTheme(
        brightness: Brightness.dark,
        background: const Color(0xFF0F172A),
        surface: const Color(0xFF1E293B),
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: indigo,
      brightness: brightness,
      surface: surface,
    );
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: brightness == Brightness.light ? navy : Colors.white,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: brightness == Brightness.light ? navy : Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: indigo, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: indigo,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
