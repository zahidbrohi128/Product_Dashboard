import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF6200EE);
  static const secondaryColor = Color(0xFF03DAC6);
  static const backgroundColorLight = Color(0xFFF7F9FC);
  static const surfaceColorLight = Colors.white;
  static const errorColor = Color(0xFFB00020);

  static const backgroundColorDark = Color(0xFF121212);
  static const surfaceColorDark = Color(0xFF1E1E1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorLight,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColorLight,
        background: backgroundColorLight,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorLight,
        elevation: 1,
        shadowColor: Colors.black26,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black12,
        color: surfaceColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(primaryColor.withOpacity(0.1)),
        dataRowColor: MaterialStateProperty.all(surfaceColorLight),
        dividerThickness: 0,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColorDark,
        background: backgroundColorDark,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorDark,
        elevation: 1,
        shadowColor: Colors.black54,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black26,
        color: surfaceColorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(primaryColor.withOpacity(0.2)),
        dataRowColor: MaterialStateProperty.all(surfaceColorDark),
        dividerThickness: 0,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: secondaryColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}