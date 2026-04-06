import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static bool _isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color _text(BuildContext context) =>
      _isDark(context) ? AppColors.darkText : AppColors.lightText;

  static Color _sub(BuildContext context) =>
      _isDark(context) ? AppColors.darkTextSub : AppColors.lightTextSub;

  static Color _hint(BuildContext context) =>
      _isDark(context) ? AppColors.darkTextHint : AppColors.lightTextHint;

  static TextStyle _base(BuildContext context) => GoogleFonts.inter(
        color: _text(context),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
      );

  static TextStyle balanceHero(BuildContext context) => _base(context).copyWith(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.softIvory,
      );

  static TextStyle screenTitle(BuildContext context) => _base(context).copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      );

  static TextStyle cardTitle(BuildContext context) => _base(context).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle bodyText(BuildContext context) => _base(context).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.35,
      );

  static TextStyle labelSmall(BuildContext context) => _base(context).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _sub(context),
      );

  static TextStyle amountPositive(BuildContext context) => _base(context).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.income,
      );

  static TextStyle amountNegative(BuildContext context) => _base(context).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.expense,
      );

  static TextStyle hintText(BuildContext context) => _base(context).copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _hint(context),
      );

  static TextStyle headlineLarge(BuildContext context) => _base(context).copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
      );

  static TextStyle headlineMedium(BuildContext context) => _base(context).copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
      );

  static TextStyle headlineSmall(BuildContext context) => _base(context).copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      );

  static TextStyle titleLarge(BuildContext context) => _base(context).copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle titleMedium(BuildContext context) => _base(context).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle titleSmall(BuildContext context) => _base(context).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle bodyLarge(BuildContext context) => _base(context).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle bodyMedium(BuildContext context) => bodyText(context);

  static TextStyle bodySmall(BuildContext context) => _base(context).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _sub(context),
        height: 1.35,
      );

  static TextStyle labelLarge(BuildContext context) => _base(context).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle labelMedium(BuildContext context) => _base(context).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  static TextStyle caption(BuildContext context) => _base(context).copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: _hint(context),
      );
}
