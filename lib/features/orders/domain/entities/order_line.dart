import 'package:equatable/equatable.dart';

/// Snapshot of a cart row stored inside an order, so old orders keep their
/// name and price even if the catalog changes.
class OrderLine extends Equatable {
  const OrderLine({
    required this.productId,
    required this.name,
    required this.image,
    required this.color,
    required this.quantity,
    required this.price,
  });

  final String productId;
  final String name;
  final String image;
  final String color;
  final int quantity;
  final int price;

  int get subtotal => price * quantity;

  @override
  List<Object?> get props => [productId, name, color, quantity, price];
}
