import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF1E112A); // Deep Royal Purple
  static const Color accentColor = Color(0xFFD6A054);  // Elegant Gold
  static const Color backgroundColor = Color(0xFFF8F8F8); // Off-white luxury
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF757575);
  static const Color errorColor = Color(0xFFE57373);

  // Light Theme
  static ThemeData get lightTheme {
    return _baseTheme(Brightness.light);
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return _baseTheme(Brightness.dark);
  }

  static ThemeData _baseTheme(Brightness brightness) {
    bool isDark = brightness == Brightness.dark;
    Color scaffoldBg = isDark ? const Color(0xFF0F0817) : backgroundColor;
    Color textCol = isDark ? Colors.white : textDark;
    Color subTextCol = isDark ? Colors.grey.shade400 : textLight;
    Color cardCol = isDark ? const Color(0xFF1E112A) : Colors.white;

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: cardCol,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: accentColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        background: scaffoldBg,
        onBackground: textCol,
        surface: cardCol,
        onSurface: textCol,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : primaryColor),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: isDark ? Colors.white : primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textCol,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textCol,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textCol,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: subTextCol,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardCol,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: subTextCol),
        hintStyle: GoogleFonts.inter(color: subTextCol.withOpacity(0.5)),
      ),
    );
  }
}
