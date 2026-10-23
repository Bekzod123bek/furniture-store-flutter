import 'dart:math' as math;

import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';
import 'package:furniture_store/features/room_design/domain/entities/palette_color.dart';

/// Decides how well a product colour goes with the colours of a room, using
/// the classic colour-wheel rules: neighbours and neutrals blend, opposites
/// work as an accent, everything else clashes a little.
abstract final class ColorHarmony {
  /// A colour with almost no saturation, or very dark / very light.
  static bool isNeutral(int argb) => _Hsl.fromArgb(argb).isNeutral;

  /// Hue distance (degrees, 0..180) -> harmony. Neighbouring hues blend,
  /// 90 degrees is the weakest pairing, a triad (120) is fine again and the
  /// opposite colour (180) is a good accent. Values between the points are
  /// interpolated, so there are no sudden jumps.
  static const _curve = <(double, double)>[
    (0, 1.0),
    (30, 1.0),
    (60, 0.8),
    (90, 0.45),
    (120, 0.55),
    (150, 0.5),
    (180, 0.75),
  ];

  /// How well two colours go together, 0..1.
  static double pairScore(int a, int b) {
    final x = _Hsl.fromArgb(a);
    final y = _Hsl.fromArgb(b);
    if (x.isNeutral || y.isNeutral) return 0.85;
    final diff = (x.h - y.h).abs();
    return _interpolate(math.min(diff, 360 - diff));
  }

  static double _interpolate(double distance) {
    for (var i = 1; i < _curve.length; i++) {
      final (d1, v1) = _curve[i];
      if (distance <= d1) {
        final (d0, v0) = _curve[i - 1];
        return v0 + (v1 - v0) * (distance - d0) / (d1 - d0);
      }
    }
    return _curve.last.$2;
  }

  /// How well [argb] goes with the whole [palette], weighted by how much of
  /// the room each palette colour covers.
  static double paletteScore(int argb, List<PaletteColor> palette) {
    if (palette.isEmpty) return 0.5;
    var weighted = 0.0;
    var total = 0.0;
    for (final color in palette) {
      final weight = color.share <= 0 ? 0.01 : color.share;
      weighted += weight * pairScore(argb, color.argb);
      total += weight;
    }
    return weighted / total;
  }

  /// The colour variant of [product] that suits [palette] best.
  static ({ProductColor color, double score}) bestColor(
    Product product,
    List<PaletteColor> palette,
  ) {
    var best = product.colors.first;
    var bestScore = -1.0;
    for (final color in product.colors) {
      final score = paletteScore(color.argb, palette);
      if (score > bestScore) {
        best = color;
        bestScore = score;
      }
    }
    return (color: best, score: bestScore);
  }
}

class _Hsl {
  const _Hsl(this.h, this.s, this.l);

  /// Hue 0..360, saturation 0..1, lightness 0..1.
  final double h;
  final double s;
  final double l;

  /// Almost no colour: greys, black, white.
  bool get isNeutral => s < 0.15 || l < 0.12 || l > 0.92;

  factory _Hsl.fromArgb(int argb) {
    final r = ((argb >> 16) & 0xFF) / 255;
    final g = ((argb >> 8) & 0xFF) / 255;
    final b = (argb & 0xFF) / 255;
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final l = (max + min) / 2;
    final delta = max - min;
    if (delta == 0) return _Hsl(0, 0, l);
    final s = delta / (1 - (2 * l - 1).abs());
    final double h;
    if (max == r) {
      h = 60 * (((g - b) / delta) % 6);
    } else if (max == g) {
      h = 60 * ((b - r) / delta + 2);
    } else {
      h = 60 * ((r - g) / delta + 4);
    }
    return _Hsl(h, s, l);
  }
}
