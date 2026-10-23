import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_line.dart';

/// What is stored for a cart: rows by id plus the promo code.
class CartSnapshot extends Equatable {
  const CartSnapshot({this.lines = const [], this.promoCode});

  final List<CartLine> lines;
  final String? promoCode;

  @override
  List<Object?> get props => [lines, promoCode];
}
