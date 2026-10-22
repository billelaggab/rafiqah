// lib/app/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge =>
      GoogleFonts.tajawal(fontSize: 32, fontWeight: FontWeight.bold);
  static TextStyle get titleLarge =>
      GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.w600);
  static TextStyle get titleMedium =>
      GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get bodyLarge => GoogleFonts.tajawal(fontSize: 16);
  static TextStyle get bodyMedium => GoogleFonts.tajawal(fontSize: 14);
  static TextStyle get bodySmall => GoogleFonts.tajawal(fontSize: 12);
  static TextStyle get labelLarge =>
      GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.w600);
}