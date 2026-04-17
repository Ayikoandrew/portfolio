import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF2563EB);
  static const accent = Color(0xFF06B6D4);
  static const accentDark = Color(0xFF0891B2);

  // Dark theme
  static const darkBg = Color(0xFF0B0F19);
  static const darkSurface = Color(0xFF111827);
  static const darkCard = Color(0xFF1E293B);
  static const darkBorder = Color(0xFF1F2937);
  static const darkText = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);

  // Light theme
  static const lightBg = Color(0xFFF8FAFC);
  static const lightSurface = Color.from(alpha: 1, red: 0.969, green: 0.882, blue: 0.882);
  static const lightCard = Color(0xFFF1F5F9);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightText = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);

  // Semantic
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  // Gradient
  static const gradientColors = [primary, accent];
}
