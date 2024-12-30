// theme.dart

import 'package:flutter/material.dart';

class DevThemeConfig {
  // Define the colors with easy-to-understand variable names
  static const Color devPrimaryColor = Color(0xFF0B3954); // Dark Blue
  static const Color devSecondaryColor = Color(0xFF1B998B); // Teal
  static const Color devAccentColor = Color(0xFFB279A7); // Lavender
  static const Color devBackgroundColor = Color(0xFFF8F1FF); // Cream
  static const Color devTextColor = Color(0xFFDECDF5); // Pale Purple

  // Optionally, create a ThemeData to configure the app's theme
  static ThemeData get devAppTheme {
    return ThemeData(
      primaryColor: devPrimaryColor,
      hintColor: devAccentColor,
      // econdaryColor: devSecondaryColor,
      buttonTheme: ButtonThemeData(buttonColor: devSecondaryColor),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: devTextColor),
        bodyMedium: TextStyle(color: devTextColor),
      ),
    );
  }
}
