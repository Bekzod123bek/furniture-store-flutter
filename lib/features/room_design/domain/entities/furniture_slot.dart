import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_kind.dart';

/// One place in a room that needs a piece of furniture, for example a sofa
/// or four dining chairs.
class FurnitureSlot extends Equatable {
  const FurnitureSlot({
    required this.kind,
    required this.category,
    this.quantity = 1,
    this.minWidthCm,
    this.maxWidthCm,
    this.minDepthCm,
    this.minHeightCm,
  });

  final SlotKind kind;
  final ProductCategory category;

  /// How many identical pieces the room needs (for example 4 chairs).
  final int quantity;

  /// Narrows a category, for example a coffee table is under 100 cm wide
  /// while a dining table is over 120 cm.
  final int? minWidthCm;
  final int? maxWidthCm;

  /// A dining table is deeper than a desk; a dining chair is taller than a
  /// bar stool.
  final int? minDepthCm;
  final int? minHeightCm;

  @override
  List<Object?> get props => [kind, category, quantity, minWidthCm, maxWidthCm];
}
