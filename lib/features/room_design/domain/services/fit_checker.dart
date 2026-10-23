import 'dart:math' as math;

import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';

/// Decides whether furniture physically suits a room.
abstract final class FitChecker {
  /// Furniture should cover at most this share of the floor.
  static const maxFloorUsage = 0.35;

  /// One piece may cover at most this share of the floor.
  static const maxPieceUsage = 0.25;

  /// The longest side of one piece may use at most this share of the longest
  /// wall.
  static const maxWallUsage = 0.65;

  /// Total floor area furniture may use in [room], in square metres.
  static double floorBudgetM2(RoomDimensions room) =>
      room.areaM2 * maxFloorUsage;

  /// Whether [product] is small enough for [room]. Things that do not stand
  /// on the floor (pendant lamps, wall shelves) always fit.
  static bool fits(Product product, RoomDimensions room) {
    if (!product.floorStanding) return true;
    final size = product.dimensions;
    final longestSide = math.max(size.widthCm, size.depthCm);
    return longestSide <= room.longestWallCm * maxWallUsage &&
        size.footprintM2 <= room.areaM2 * maxPieceUsage;
  }

  /// How comfortably [product] sits in [room], 0..1. A piece using up to 10%
  /// of the floor scores 1; the score falls to 0.4 at the 25% limit.
  static double sizeScore(Product product, RoomDimensions room) {
    if (!product.floorStanding || room.areaM2 == 0) return 1;
    final usage = product.dimensions.footprintM2 / room.areaM2;
    if (usage <= 0.10) return 1;
    if (usage >= maxPieceUsage) return 0.4;
    return 1 - (usage - 0.10) / (maxPieceUsage - 0.10) * 0.6;
  }
}
