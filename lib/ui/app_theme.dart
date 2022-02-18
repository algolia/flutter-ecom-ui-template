import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._internal();

  static const Color nebula = Color(0xFF5468FF);
  static const Color darkBlue = Color(0xFF21243D);
  static const Color darkPink = Color(0xFFAA086C);
  static const Color vividOrange = Color(0xFFE8600A);
  static const Color darkRed = Color(0xFFB00020);

  static ThemeData buildLightTheme() {
    const Color primaryColor = AppTheme.nebula;
    const Color secondaryColor = AppTheme.darkBlue;
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    return ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
        primaryColor: primaryColor,
        indicatorColor: Colors.white,
        canvasColor: Colors.white,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        errorColor: darkRed,
        colorScheme: colorScheme,
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: secondaryColor,
          backgroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: secondaryColor)));
  }
}
