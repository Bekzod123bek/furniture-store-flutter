import 'package:equatable/equatable.dart';

/// The saved form of a cart row: ids only, so prices always come from the
/// current catalog.
class CartLine extends Equatable {
  const CartLine({
    required this.productId,
    required this.colorName,
    required this.quantity,
  });

  final String productId;
  final String colorName;
  final int quantity;

  @override
  List<Object?> get props => [productId, colorName, quantity];
}
