import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

abstract final class AppTheme {
  // ── Shared constants ─────────────────────────────────────
  static const double fieldRadius = 12;
  static const double buttonRadius = 30; // أزرار ممتلئة مستديرة كما في التصميم
  static const double cardRadius = 16;
  static const double homeSpacing = 16;

  static const homePadding = EdgeInsets.fromLTRB(16, 20, 16, 20);
  static const homeHeaderPadding = EdgeInsets.fromLTRB(16, 16, 16, 12);
  static const coursePadding = EdgeInsets.all(8);

  static const courseImageRadius = BorderRadius.all(Radius.circular(12));

  // ── Light Theme ──────────────────────────────────────────
  static ThemeData get lightTheme {
    // Input border
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(fieldRadius),
      borderSide: const BorderSide(color: AppColor.inputBorder),
    );

    // Button style – ممتلئ مستدير كما يظهر في شاشة التفاصيل
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.onPrimary,
      minimumSize: const Size(double.infinity, 52),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ── Color Scheme ────────────────────────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColor.primary,
        onPrimary: AppColor.onPrimary,
        secondary: AppColor.secondary,
        onSecondary: AppColor.onSecondary,
        secondaryContainer: AppColor.softAccent,
        onSecondaryContainer: AppColor.primary,
        surface: AppColor.surface,
        onSurface: AppColor.textPrimary,
        onSurfaceVariant: AppColor.textSecondary,
        outline: AppColor.inputBorder,
        outlineVariant: AppColor.divider,
        error: AppColor.danger,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppColor.background,

      // ── AppBar – أبيض مع نص داكن كما في الصور ──────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.surface,
        foregroundColor: AppColor.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: AppColor.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColor.textPrimary),
        actionsIconTheme: IconThemeData(color: AppColor.primary),
      ),

      // ── Typography ──────────────────────────────────────
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: AppColor.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColor.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColor.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColor.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColor.textSecondary,
        ),
      ),

      // ── Card ────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColor.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: AppColor.shadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),

      // ── Input ───────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.inputField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(fontSize: 14, color: AppColor.hint),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColor.textSecondary,
        ),
        prefixIconColor: AppColor.hint,
        suffixIconColor: AppColor.hint,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColor.danger),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColor.danger, width: 1.5),
        ),
      ),

      // ── Buttons ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primary,
          side: const BorderSide(color: AppColor.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          minimumSize: const Size(64, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Bottom Navigation Bar – أبيض مع أيقونة نشطة ────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColor.navigationBg,
        selectedItemColor: AppColor.navigationActive,
        unselectedItemColor: AppColor.navigationInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 24),
        showUnselectedLabels: true,
      ),

      // ── Navigation Bar (Material 3) ──────────────────────
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: AppColor.navigationBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 8,
        shadowColor: AppColor.shadow,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? AppColor.navigationActive
                : AppColor.navigationInactive,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
            color: states.contains(WidgetState.selected)
                ? AppColor.navigationActive
                : AppColor.navigationInactive,
          ),
        ),
      ),

      // ── Misc ────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColor.divider,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColor.primary,
        linearTrackColor: AppColor.inputField,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColor.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      iconTheme: const IconThemeData(color: AppColor.textPrimary, size: 24),
      chipTheme: ChipThemeData(
        backgroundColor: AppColor.inputField,
        selectedColor: AppColor.softAccent,
        labelStyle: const TextStyle(fontSize: 12, color: AppColor.textSecondary),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}
