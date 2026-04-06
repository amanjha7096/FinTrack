import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    final scaffold = isDark ? AppColors.darkBg : AppColors.lightBg;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final cardAlt = isDark ? AppColors.darkCardAlt : AppColors.lightCardAlt;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final subText = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final hint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
    final onPrimary = isDark ? AppColors.softIvory : AppColors.graphite;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.income,
      onPrimary: onPrimary,
      secondary: AppColors.gradientPurpleStart,
      onSecondary: AppColors.softIvory,
      error: AppColors.expense,
      onError: AppColors.softIvory,
      surface: card,
      onSurface: text,
      tertiary: AppColors.warning,
      onTertiary: AppColors.graphite,
      outline: border,
      outlineVariant: border,
      primaryContainer: cardAlt,
      onPrimaryContainer: text,
      secondaryContainer: cardAlt,
      onSecondaryContainer: text,
      tertiaryContainer: AppColors.gradientGoldStart,
      onTertiaryContainer: AppColors.graphite,
      errorContainer: AppColors.expense.withValues(alpha: 0.12),
      onErrorContainer: text,
      surfaceDim: scaffold,
      surfaceBright: cardAlt,
      surfaceContainerLowest: scaffold,
      surfaceContainerLow: card,
      surfaceContainer: cardAlt,
      surfaceContainerHigh: cardAlt,
      surfaceContainerHighest: cardAlt,
      inverseSurface: isDark ? AppColors.lightCard : AppColors.darkCard,
      onInverseSurface: isDark ? AppColors.lightText : AppColors.darkText,
      inversePrimary: AppColors.gradientTealStart,
      shadow: Colors.transparent,
      scrim: AppColors.ink.withValues(alpha: 0.6),
    );

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: text,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        color: text,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: text,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      titleSmall: base.textTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: text,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: text,
      ),
      bodySmall: base.textTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: subText,
      ),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      labelMedium: base.textTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: subText,
      ),
      labelSmall: base.textTheme.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: hint,
      ),
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffold,
      canvasColor: scaffold,
      cardColor: card,
      dividerColor: border,
      shadowColor: Colors.transparent,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.graphite : AppColors.lightCard,
        selectedItemColor: AppColors.income,
        unselectedItemColor: subText,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          color: AppColors.income,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.softIvory,
        foregroundColor: AppColors.graphite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardAlt,
        hintStyle: textTheme.bodyMedium?.copyWith(color: hint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.income, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.expense, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.expense, width: 1.2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkCardAlt : AppColors.graphite,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.softIvory),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 0.8,
        space: 1,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: cardAlt,
        selectedColor: AppColors.income.withValues(alpha: 0.18),
        secondarySelectedColor: AppColors.income.withValues(alpha: 0.18),
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        labelStyle: textTheme.labelMedium,
      ),
    );
  }
}
