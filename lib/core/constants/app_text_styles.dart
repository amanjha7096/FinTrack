import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.inter();

  static TextStyle get headlineLarge => _base.copyWith(fontSize: 32, fontWeight: FontWeight.w500, letterSpacing: -0.5);
  static TextStyle get headlineMedium => _base.copyWith(fontSize: 24, fontWeight: FontWeight.w500, letterSpacing: -0.4);
  static TextStyle get headlineSmall => _base.copyWith(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: -0.2);

  static TextStyle get titleLarge => _base.copyWith(fontSize: 18, fontWeight: FontWeight.w500);
  static TextStyle get titleMedium => _base.copyWith(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle get titleSmall => _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get bodyLarge => _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get bodyMedium => _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get bodySmall => _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);

  static TextStyle get labelLarge => _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get labelMedium => _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => _base.copyWith(fontSize: 10, fontWeight: FontWeight.w500);
}