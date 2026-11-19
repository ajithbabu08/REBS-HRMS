import 'package:flutter/material.dart';

/// Central color palette for REBS HRMS.
abstract final class AppColors {
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color accent = Color(0xFF2962FF);

  /// Green — synced / success states.
  static const Color success = Color(0xFF2E7D32);

  /// Orange — pending / warning states.
  static const Color warning = Color(0xFFE65100);

  /// Red — rejected / error states.
  static const Color error = Color(0xFFC62828);

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
}
