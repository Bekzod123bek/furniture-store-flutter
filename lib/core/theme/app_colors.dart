import 'package:flutter/material.dart';

/// Brand and status colours that are not part of the Material colour scheme.
abstract final class AppColors {
  static const brand = Color(0xFF8B5E3C);
  static const sale = Color(0xFFD9534F);
  static const rating = Color(0xFFF5A623);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFE08A00);

  /// Used for everything that belongs to the AI room feature.
  static const aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5E3C), Color(0xFFD9824B)],
  );
}
