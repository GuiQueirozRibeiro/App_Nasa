// External packages
import 'package:flutter/material.dart';

// Core module imports
import 'package:core/src/theme/theme_palette.dart';
import 'package:core/src/theme/theme_text_style.dart';

class CoreTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ThemePalette.primary,
    scaffoldBackgroundColor: ThemePalette.greyLight,
    fontFamily: 'Helvetica',
    textTheme: ThemeTextStyle.lightTextTheme,
    colorScheme: const ColorScheme.light(
      primary: ThemePalette.primary,
      secondary: ThemePalette.secondary,
      surface: ThemePalette.greyLight,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ThemePalette.primary,
    scaffoldBackgroundColor: ThemePalette.greyDark,
    fontFamily: 'Helvetica',
    textTheme: ThemeTextStyle.darkTextTheme,
    colorScheme: const ColorScheme.dark(
      primary: ThemePalette.primary,
      secondary: ThemePalette.secondary,
      surface: ThemePalette.greyDark,
    ),
  );
}
