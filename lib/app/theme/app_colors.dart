// lib/app/theme/app_colors.dart
import 'package:flutter/material.dart';

/// لوحة ألوان "رفيقة" — هادئة ومتوافقة مع WCAG AA على الخلفيات الفاتحة.
///
/// تم التحقق من نسب التباين مع الأبيض:
/// primary 5.70:1 — secondary 6.04:1 — accent/success 5.48:1 — warning 5.02:1.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF7C3AED); // lavender deep
  static const primaryLight = Color(0xFFC4B5FD);
  static const primaryDark = Color(0xFF4C1D95);
  static const secondary = Color(0xFFBE185D); // deep rose
  static const accent = Color(0xFF047857); // wellness green
  static const background = Color(0xFFFAF5FF);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFDC2626);
  static const success = Color(0xFF047857);
  static const warning = Color(0xFFB45309);

  // Gradient stops (both dark enough for white text: 5.70:1 / 7.10:1)
  static const gradientStart = Color(0xFF6D28D9);
  static const gradientEnd = Color(0xFF7C3AED);

  // Cycle phases (used as backgrounds with dark text)
  static const periodRed = Color(0xFFEF9A9A);
  static const follicularYellow = Color(0xFFFFF176);
  static const ovulationGreen = Color(0xFFA5D6A7);
  static const lutealBlue = Color(0xFF90CAF9);

  // Alert red (contraction)
  static const alertRed = Color(0xFFB91C1C);
}
