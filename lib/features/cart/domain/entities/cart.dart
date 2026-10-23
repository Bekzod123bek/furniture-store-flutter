import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_item.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_line.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/cart/domain/entities/promo_codes.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';

/// The shopping cart and all its pricing rules. Immutable: every change
/// returns a new [Cart].
class Cart extends Equatable {
  const Cart({this.items = const [], this.promoCode});

  /// Most units of one product + colour that can be ordered at once.
  static const maxQuantityPerLine = 10;

  /// Orders at or above this subtotal get free standard delivery.
  static const freeDeliveryFrom = 1000;
  static const standardDeliveryFee = 25;

  /// Extra charge for express delivery, on top of the standard fee.
  static const expressSurcharge = 40;

  final List<CartItem> items;

  /// A valid, normalised promo code, or `null`.
  final String? promoCode;

  bool get isEmpty => items.isEmpty;

  int get count => items.fold(0, (sum, i) => sum + i.quantity);

  int get subtotal => items.fold(0, (sum, i) => sum + i.subtotal);

  int get discount {
    final code = promoCode;
    final rate = code == null ? null : PromoCodes.rateFor(code);
    return rate == null ? 0 : (subtotal * rate).round();
  }

  /// Standard delivery fee: free for big orders.
  int get standardDelivery =>
      isEmpty || subtotal >= freeDeliveryFrom ? 0 : standardDeliveryFee;

  int deliveryFee(DeliveryMethod method) => switch (method) {
    DeliveryMethod.standard => standardDelivery,
    DeliveryMethod.express =>
      standardDelivery + (isEmpty ? 0 : expressSurcharge),
  };

  int total([DeliveryMethod method = DeliveryMethod.standard]) =>
      subtotal - discount + deliveryFee(method);

  /// How much more must be added to get free delivery, or 0.
  int get amountToFreeDelivery =>
      isEmpty ? 0 : math.max(0, freeDeliveryFrom - subtotal);

  /// Adds [quantity] units, merging with an existing row of the same product
  /// and colour. Never goes above [maxQuantityPerLine].
  Cart add(Product product, {ProductColor? color, int quantity = 1}) {
    final line = CartItem(
      product: product,
      color: color ?? product.colors.first,
      quantity: quantity.clamp(1, maxQuantityPerLine),
    );
    final index = items.indexWhere(line.sameLine);
    final next = [...items];
    if (index == -1) {
      next.add(line);
    } else {
      next[index] = next[index].copyWith(
        quantity: math.min(
          maxQuantityPerLine,
          next[index].quantity + line.quantity,
        ),
      );
    }
    return Cart(items: next, promoCode: promoCode);
  }

  /// Sets the quantity of [item]. A quantity of 0 or less removes the row.
  Cart setQuantity(CartItem item, int quantity) {
    final next = [
      for (final i in items)
        if (!i.sameLine(item))
          i
        else if (quantity > 0)
          i.copyWith(quantity: math.min(quantity, maxQuantityPerLine)),
    ];
    return Cart(items: next, promoCode: next.isEmpty ? null : promoCode);
  }

  Cart remove(CartItem item) => setQuantity(item, 0);

  /// Applies [code], or returns `null` when it is not a valid promo code.
  Cart? applyPromo(String code) {
    if (!PromoCodes.isValid(code)) return null;
    return Cart(items: items, promoCode: PromoCodes.normalize(code));
  }

  Cart removePromo() => Cart(items: items);

  /// The saved form of this cart.
  List<CartLine> toLines() => [
    for (final i in items)
      CartLine(
        productId: i.product.id,
        colorName: i.color.name,
        quantity: i.quantity,
      ),
  ];

  @override
  List<Object?> get props => [items, promoCode];
}
