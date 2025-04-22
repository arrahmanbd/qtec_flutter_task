import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightColorScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
  textTheme: TextTheme(),
);
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkColorScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
  ),
  textTheme: TextTheme(),
);
