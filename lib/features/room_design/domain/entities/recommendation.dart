import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';
import 'package:furniture_store/features/room_design/domain/entities/match_reason.dart';

/// A product suggested for a room, with the colour that suits it best.
class Recommendation extends Equatable {
  const Recommendation({
    required this.product,
    required this.color,
    required this.quantity,
    required this.styleScore,
    required this.colorScore,
    required this.sizeScore,
    required this.score,
    required this.reasons,
  });

  final Product product;
  final ProductColor color;
  final int quantity;

  /// Each score is 0..1.
  final double styleScore;
  final double colorScore;
  final double sizeScore;
  final double score;

  /// Why this product was chosen, most important first.
  final List<MatchReason> reasons;

  int get totalPrice => product.price * quantity;

  double get floorAreaM2 => product.floorAreaM2 * quantity;

  @override
  List<Object?> get props => [product, color, quantity, score];
}
