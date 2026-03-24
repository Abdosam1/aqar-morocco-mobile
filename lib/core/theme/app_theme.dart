import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Masterpiece Palette (Inspired by high-fidelity design)
  static const Color primaryEmerald = Color(0xFF10B981); // Vibrant Emerald
  static const Color darkBackground = Color(0xFF0F172A); // Deep Slate/Navy
  static const Color cardDark = Color(0xFF1E293B); // Lighter Slate for cards
  static const Color borderDark = Color(0xFF334155); // Subtle Border
  static const Color textMain = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color accentGold = Color(0xFFFACC15); // Yellow 400

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryEmerald,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryEmerald,
        secondary: primaryEmerald,
        surface: cardDark,
        onSurface: textMain,
        background: darkBackground,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: textMain,
        displayColor: textMain,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textMain),
        titleTextStyle: GoogleFonts.outfit(
          color: textMain,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryEmerald, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBackground,
        selectedItemColor: primaryEmerald,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // Keeping light theme for fallback, but main focus is darkTheme
  static ThemeData get lightTheme => darkTheme; 
}
