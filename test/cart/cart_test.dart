import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/cart/domain/entities/promo_codes.dart';

import '../helpers/seed_catalog.dart';

void main() {
  final sofa = SeedCatalog.byId('p1'); // $899, three colours
  final chair = SeedCatalog.byId('p8'); // $120

  group('Cart', () {
    test('merges the same product and colour, keeps other colours apart', () {
      final cart = const Cart()
          .add(sofa)
          .add(sofa, quantity: 2)
          .add(sofa, color: sofa.colors[1]);
      expect(cart.items, hasLength(2));
      expect(cart.count, 4);
      expect(cart.subtotal, 899 * 4);
    });

    test('quantity is capped at ${Cart.maxQuantityPerLine} per line', () {
      var cart = const Cart().add(chair, quantity: 8).add(chair, quantity: 8);
      expect(cart.items.single.quantity, Cart.maxQuantityPerLine);
      cart = cart.setQuantity(cart.items.single, 99);
      expect(cart.items.single.quantity, Cart.maxQuantityPerLine);
      expect(
        const Cart().add(chair, quantity: 50).count,
        Cart.maxQuantityPerLine,
      );
    });

    test('setQuantity to zero removes the row and drops the promo', () {
      var cart = const Cart().add(chair).applyPromo('SALE10')!;
      expect(cart.promoCode, 'SALE10');
      cart = cart.remove(cart.items.single);
      expect(cart.isEmpty, isTrue);
      expect(cart.promoCode, isNull);
    });

    test('promo codes: case insensitive, unknown codes are refused', () {
      final cart = const Cart().add(chair);
      expect(cart.applyPromo('nope'), isNull);
      final withPromo = cart.applyPromo(' sale10 ')!;
      expect(withPromo.promoCode, 'SALE10');
      expect(withPromo.discount, 12);
      expect(withPromo.removePromo().discount, 0);
      expect(PromoCodes.rateFor('welcome20'), 0.2);
    });

    test('delivery is free from \$${Cart.freeDeliveryFrom}', () {
      final small = const Cart().add(chair);
      expect(small.standardDelivery, Cart.standardDeliveryFee);
      expect(small.amountToFreeDelivery, Cart.freeDeliveryFrom - 120);
      final big = small.add(sofa, quantity: 2);
      expect(big.standardDelivery, 0);
      expect(big.amountToFreeDelivery, 0);
      expect(const Cart().standardDelivery, 0);
    });

    test('express delivery adds a surcharge; totals add up', () {
      final cart = const Cart().add(chair).applyPromo('SALE10')!;
      expect(cart.total(), 120 - 12 + Cart.standardDeliveryFee);
      expect(
        cart.total(DeliveryMethod.express),
        120 - 12 + Cart.standardDeliveryFee + Cart.expressSurcharge,
      );
      expect(const Cart().total(DeliveryMethod.express), 0);
    });

    test('toLines keeps only ids, colour and quantity', () {
      final lines = const Cart()
          .add(sofa, color: sofa.colors[2], quantity: 3)
          .toLines();
      expect(lines.single.productId, 'p1');
      expect(lines.single.colorName, sofa.colors[2].name);
      expect(lines.single.quantity, 3);
    });
  });
}
