import 'package:flutter/material.dart';

abstract final class AppColor {
  // ── Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFFE8552C);
  static const Color primaryLight = Color(0xFFF4763F);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFFFFF3EF);
  static const Color onSecondary = primary;       // نفس اللون الأساسي
  static const Color softAccent = secondary;      // نفس اللون الثانوي

  // ── Background & Surface ─────────────────────────────────
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);

  // ── Input Field ──────────────────────────────────────────
  static const Color inputField = Color(0xFFF2F2F2);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color hint = Color(0xFFAAAAAA);

  // ── UI Utilities ─────────────────────────────────────────
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x14000000);
  static const Color danger = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  // ── Navigation Bar ───────────────────────────────────────
  static const Color navigationBg = surface;      // نفس السطح الأبيض
  static const Color navigationActive = primary;  // نفس اللون الأساسي
  static const Color navigationInactive = Color(0xFFBDBDBD);
}
