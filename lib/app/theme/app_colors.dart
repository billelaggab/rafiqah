// lib/app/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Calm palette (refined for accessibility: 4.5:1+ contrast)
  static const primary = Color(0xFF6B5B95); // deep soft purple
  static const primaryLight = Color(0xFF9B8FC4);
  static const primaryDark = Color(0xFF4A3F6B);
  static const secondary = Color(0xFFD97B9F); // dusty rose
  static const accent = Color(0xFF5BA8D0); // calm blue
  static const background = Color(0xFFF5F3FA);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const warning = Color(0xFFF57C00);

  // Cycle phases
  static const periodRed = Color(0xFFEF9A9A);
  static const follicularYellow = Color(0xFFFFF176);
  static const ovulationGreen = Color(0xFFA5D6A7);
  static const lutealBlue = Color(0xFF90CAF9);

  // Alert red (contraction)
  static const alertRed = Color(0xFFD32F2F);
}