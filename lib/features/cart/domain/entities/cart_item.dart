import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.color,
    required this.quantity,
  });

  final Product product;
  final ProductColor color;
  final int quantity;

  int get subtotal => product.price * quantity;

  /// Whether [other] is the same product in the same colour.
  bool sameLine(CartItem other) =>
      other.product == product && other.color == color;

  CartItem copyWith({int? quantity}) => CartItem(
    product: product,
    color: color,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [product, color, quantity];
}
