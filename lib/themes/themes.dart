import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';

// Function to build the light theme
ThemeData buildLightTheme() {
  return ThemeData(
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightAccent, // This is the accent color
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: _buildTextTheme(AppColors.lightText),
    dividerColor: AppColors.lightDivider,
    iconTheme: const IconThemeData(color: AppColors.lightIcon),
  );
}

// Function to build the dark theme
ThemeData buildDarkTheme() {
  return ThemeData(
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent, // This is the accent color
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: _buildTextTheme(AppColors.darkText),
    dividerColor: AppColors.darkDivider,
    iconTheme: const IconThemeData(color: AppColors.darkIcon),
  );
}

// Function to build text theme with the specified color
TextTheme _buildTextTheme(Color color) {
  return TextTheme(
    displayLarge: TextStyle(fontSize: 24, color: color),
    bodyLarge: TextStyle(fontSize: 16, color: color),
  );
}
