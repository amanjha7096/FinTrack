import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const softIvory = Color(0xFFF2F0EA);
  static const warmPaper = Color(0xFFF4F0E8);
  static const warmPaperAlt = Color(0xFFE9E1D6);
  static const graphite = Color(0xFF23211F);
  static const ink = Color(0xFF111110);
  static const inkSoft = Color(0xFF171717);
  static const inkAlt = Color(0xFF1E1E1C);
  static const inkAlt2 = Color(0xFF282826);
  static const borderDark = Color(0xFF2E2E2C);
  static const borderLight = Color(0xFFD7D0C5);
  static const textMain = Color(0xFFF1EFE8);
  static const textBody = Color(0xFF2F2C28);
  static const textSubtle = Color(0xFF888780);
  static const textHinted = Color(0xFF6E6A64);
  static const textHintedDark = Color(0xFF444441);

  // Brand gradients.
  static const gradientPrimaryStart = Color(0xFFEFD9C7);
  static const gradientPrimaryEnd = Color(0xFF79D1B1);
  static const gradientTealStart = Color(0xFF52D4C7);
  static const gradientTealEnd = Color(0xFF2E8F84);
  static const gradientBlueStart = Color(0xFF63AEEF);
  static const gradientBlueEnd = Color(0xFF356EBC);
  static const gradientPurpleStart = Color(0xFFD987E6);
  static const gradientPurpleEnd = Color(0xFF7B4DC2);
  static const gradientGoldStart = Color(0xFFF3D58A);
  static const gradientGoldEnd = Color(0xFFB88A2D);
  static const notification = Color(0xFFE84C57);

  // Health-reactive balance gradients.
  static const List<Color> healthGood = [Color(0xFF1D9E75), Color(0xFF0A5C45)];
  static const List<Color> healthWarn = [Color(0xFFEF9F27), Color(0xFF7A4A08)];
  static const List<Color> healthDanger = [Color(0xFFE24B4A), Color(0xFF8A1F1F)];

  // Light theme.
  static const lightBg = Color(0xFFF4F0E8);
  static const lightCard = Color(0xFFFBF7F0);
  static const lightCardAlt = Color(0xFFE9E1D6);
  static const lightBorder = Color(0xFFD7D0C5);
  static const lightText = Color(0xFF2F2C28);
  static const lightTextSub = Color(0xFF6E6A64);
  static const lightTextHint = Color(0xFFA39B91);

  // Dark theme.
  static const darkBg = Color(0xFF111110);
  static const darkCard = Color(0xFF1E1E1C);
  static const darkCardAlt = Color(0xFF282826);
  static const darkBorder = Color(0xFF2E2E2C);
  static const darkText = Color(0xFFF1EFE8);
  static const darkTextSub = Color(0xFF888780);
  static const darkTextHint = Color(0xFF444441);

  // Semantic.
  static const income = Color(0xFF1D9E75);
  static const expense = Color(0xFFE24B4A);
  static const warning = Color(0xFFEF9F27);

  // Category accents.
  static const salary = income;
  static const otherIncome = Color(0xFF0F6E56);
  static const food = expense;
  static const transport = Color(0xFF378ADD);
  static const shopping = Color(0xFFD4537E);
  static const entertainment = Color(0xFF7B4DC2);
  static const health = income;
  static const utilities = warning;
  static const education = Color(0xFF185FA5);
  static const travel = Color(0xFF639922);
  static const personal = Color(0xFFD85A30);
  static const home = Color(0xFF888780);

  // Compatibility aliases for existing widgets while we upgrade step by step.
  static const primary = income;
  static const accent = Color(0xFF7B4DC2);
  static const danger = expense;
  static const neutral = lightTextSub;

  static const lightScaffold = lightBg;
  static const lightPrimaryContainer = lightCardAlt;
  static const lightSurface = lightCard;
  static const lightDivider = lightBorder;
  static const lightTextPrimary = lightText;
  static const lightTextSecondary = lightTextSub;

  static const darkScaffold = darkBg;
  static const darkPrimaryContainer = darkCardAlt;
  static const darkSurface = darkCard;
  static const darkDivider = darkBorder;
  static const darkTextPrimary = darkText;
  static const darkTextSecondary = darkTextSub;
}
