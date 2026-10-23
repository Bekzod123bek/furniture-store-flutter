import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering grey block used while content loads.
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.width, this.height, this.radius = 0});

  /// Turned off in widget tests so `pumpAndSettle` can finish.
  static bool animate = true;

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? const Color(0xFF2A2621) : const Color(0xFFE9E4DE);
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: animate ? Colors.white : base,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (!animate) return box;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: dark ? const Color(0xFF3A352F) : const Color(0xFFF7F3EF),
      child: box,
    );
  }
}
