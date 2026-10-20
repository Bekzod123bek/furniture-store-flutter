import 'package:equatable/equatable.dart';

enum Category { sofa, table, chair, bed }

extension CategoryLabel on Category {
  String get label => switch (this) {
        Category.sofa => 'Sofas',
        Category.table => 'Tables',
        Category.chair => 'Chairs',
        Category.bed => 'Beds',
      };
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.colorValue,
  });

  final String id;
  final String name;
  final Category category;
  final int price;
  final String description;
  final int colorValue;

  @override
  List<Object?> get props => [id];
}

class CartItem extends Equatable {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}
