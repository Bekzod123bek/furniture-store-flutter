import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_set.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_slot.dart';
import 'package:furniture_store/features/room_design/domain/entities/match_reason.dart';
import 'package:furniture_store/features/room_design/domain/entities/recommendation.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_recommendation.dart';
import 'package:furniture_store/features/room_design/domain/services/color_harmony.dart';
import 'package:furniture_store/features/room_design/domain/services/fit_checker.dart';
import 'package:furniture_store/features/room_design/domain/services/style_matcher.dart';

/// Builds a furniture set for a room: for every piece the room type needs it
/// picks the products that match the room's style and colours, fit its size,
/// and keep the total floor use under control.
///
/// Pure and synchronous, so the set can be rebuilt instantly when the user
/// corrects the room type, style or size.
class RecommendFurniture {
  const RecommendFurniture();

  static const _styleWeight = 0.40;
  static const _colorWeight = 0.30;
  static const _sizeWeight = 0.20;
  static const _ratingWeight = 0.10;

  /// How many alternatives the user can swap between for each piece.
  static const candidatesPerSlot = 3;

  FurnitureSet call(List<Product> products, RoomAnalysis room) {
    var remainingM2 = FitChecker.floorBudgetM2(room.dimensions);
    final slots = <SlotRecommendation>[];
    final unfilled = <FurnitureSlot>[];

    for (final slot in room.roomType.slots) {
      final candidates =
          [
            for (final product in products)
              if (_isCandidate(product, slot, room, remainingM2))
                _rank(product, slot, room),
          ]..sort((a, b) {
            final byScore = b.score.compareTo(a.score);
            return byScore != 0
                ? byScore
                : a.product.id.compareTo(b.product.id);
          });

      if (candidates.isEmpty) {
        unfilled.add(slot);
        continue;
      }
      final top = candidates.take(candidatesPerSlot).toList();
      remainingM2 -= top.first.floorAreaM2;
      slots.add(SlotRecommendation(slot: slot, candidates: top));
    }
    return FurnitureSet(slots: slots, unfilled: unfilled);
  }

  bool _isCandidate(
    Product product,
    FurnitureSlot slot,
    RoomAnalysis room,
    double remainingM2,
  ) {
    if (product.category != slot.category) return false;
    final size = product.dimensions;
    if (slot.minWidthCm != null && size.widthCm < slot.minWidthCm!) {
      return false;
    }
    if (slot.maxWidthCm != null && size.widthCm > slot.maxWidthCm!) {
      return false;
    }
    if (slot.minDepthCm != null && size.depthCm < slot.minDepthCm!) {
      return false;
    }
    if (slot.minHeightCm != null && size.heightCm < slot.minHeightCm!) {
      return false;
    }
    if (!FitChecker.fits(product, room.dimensions)) return false;
    return product.floorAreaM2 * slot.quantity <= remainingM2;
  }

  Recommendation _rank(Product product, FurnitureSlot slot, RoomAnalysis room) {
    final style = StyleMatcher.score(product, room);
    final color = ColorHarmony.bestColor(product, room.palette);
    final size = FitChecker.sizeScore(product, room.dimensions);
    final rating = (product.rating / 5).clamp(0.0, 1.0);
    final score =
        style * _styleWeight +
        color.score * _colorWeight +
        size * _sizeWeight +
        rating * _ratingWeight;

    return Recommendation(
      product: product,
      color: color.color,
      quantity: slot.quantity,
      styleScore: style,
      colorScore: color.score,
      sizeScore: size,
      score: score,
      reasons: _reasons(product, room, style, color.score, color.color.name),
    );
  }

  List<MatchReason> _reasons(
    Product product,
    RoomAnalysis room,
    double style,
    double color,
    String colorName,
  ) {
    final secondary = room.secondaryStyle;
    return [
      if (style >= 1)
        SameStyleReason(room.style)
      else if (style >= 0.75 && secondary != null)
        SecondaryStyleReason(secondary)
      else if (style >= 0.5)
        RelatedStyleReason(room.style),
      if (color >= 0.8)
        ColorReason(colorName, [for (final c in room.palette.take(2)) c.name]),
      if (product.floorStanding)
        SizeReason(
          widthCm: product.dimensions.widthCm,
          floorPercent:
              (product.dimensions.footprintM2 / room.dimensions.areaM2 * 100)
                  .round(),
        )
      else
        const NoFloorSpaceReason(),
    ];
  }
}
