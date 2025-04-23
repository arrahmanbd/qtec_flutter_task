import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundColor,
    foregroundColor: AppColors.textPrimary,
  ),
  textTheme: TextTheme(),
  iconTheme: IconThemeData(color: AppColors.textPrimary),
  fontFamily: 'Inter',
);
