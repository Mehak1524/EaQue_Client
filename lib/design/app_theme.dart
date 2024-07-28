import 'package:client/design/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.yellowBgColor),
    scaffoldBackgroundColor: AppColors.scaffoldBgColor,
  );
}
