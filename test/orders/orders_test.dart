import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/utils/id_generator.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_line.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/orders/data/models/order_model.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/domain/usecases/cancel_order.dart';
import 'package:furniture_store/features/orders/domain/usecases/get_orders.dart';
import 'package:furniture_store/features/orders/domain/usecases/get_saved_address.dart';
import 'package:furniture_store/features/orders/domain/usecases/place_order.dart';
import 'package:furniture_store/features/orders/presentation/cubit/checkout_cubit.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_cubit.dart';

import '../helpers/fakes.dart';
import '../helpers/seed_catalog.dart';

class _FixedIds implements IdGenerator {
  int calls = 0;

  @override
  String newId() => 'order${++calls}abcdef';
}

void main() {
  final chair = SeedCatalog.byId('p8'); // $120
  final sofa = SeedCatalog.byId('p1'); // $899
  const address = ShippingAddress(
    fullName: 'Test Customer',
    phone: '+998 90 000 00 00',
    city: 'Tashkent',
    street: 'Test street 1',
  );
  final now = DateTime(2030, 5, 1, 12);

  late FakeOrdersRepository orders;
  late FakeCartRepository cartStorage;
  late PlaceOrder placeOrder;

  setUp(() {
    orders = FakeOrdersRepository();
    cartStorage = FakeCartRepository()
      ..saved = const CartSnapshot(
        lines: [CartLine(productId: 'p8', colorName: 'Black', quantity: 2)],
      );
    placeOrder = PlaceOrder(orders, cartStorage);
  });

  PlaceOrderParams params(
    Cart cart, {
    DeliveryMethod? delivery,
    String id = 'abc123xyz',
  }) => PlaceOrderParams(
    orderId: id,
    cart: cart,
    delivery: delivery ?? DeliveryMethod.standard,
    address: address,
    payment: PaymentMethod.cardOnDelivery,
    now: now,
  );

  group('PlaceOrder', () {
    test(
      'turns the cart into an order, empties the cart, remembers the address',
      () async {
        final cart = const Cart()
            .add(chair, quantity: 2)
            .applyPromo('WELCOME20')!;
        final order = (await placeOrder(params(cart))).valueOrNull!;

        expect(order.total, 240 - 48 + Cart.standardDeliveryFee);
        expect(order.itemCount, 2);
        expect(order.lines.single.name, chair.name);
        expect(order.lines.single.price, chair.price);
        expect(order.status, OrderStatus.processing);
        expect(order.number, 'FS-ABC123');
        expect(orders.orders.single.id, 'abc123xyz');
        expect(cartStorage.saved.lines, isEmpty);
        expect(orders.address, address);
      },
    );

    test('express delivery is charged', () async {
      final cart = const Cart().add(sofa, quantity: 2); // free standard
      final order = (await placeOrder(
        params(cart, delivery: DeliveryMethod.express),
      )).valueOrNull!;
      expect(order.delivery, Cart.expressSurcharge);
    });

    test('refuses an empty cart or an incomplete address', () async {
      expect(
        (await placeOrder(params(const Cart()))).failureOrNull,
        isA<ValidationFailure>(),
      );
      final incomplete = PlaceOrderParams(
        orderId: 'x',
        cart: const Cart().add(chair),
        delivery: DeliveryMethod.standard,
        address: const ShippingAddress(
          fullName: 'A',
          phone: '12',
          city: 'T',
          street: 'S',
        ),
        payment: PaymentMethod.cashOnDelivery,
        now: now,
      );
      expect(
        (await placeOrder(incomplete)).failureOrNull,
        isA<ValidationFailure>(),
      );
      expect(orders.orders, isEmpty);
    });

    test('a failed order keeps the cart', () async {
      orders.placeFailure = const NetworkFailure();
      final result = await placeOrder(params(const Cart().add(chair)));
      expect(result.failureOrNull, const NetworkFailure());
      expect(cartStorage.saved.lines, isNotEmpty);
    });

    test('placing the same order id twice creates one order', () async {
      final cart = const Cart().add(chair);
      await placeOrder(params(cart));
      await placeOrder(params(cart));
      expect(orders.orders, hasLength(1));
    });
  });

  group('OrderModel', () {
    test('round trips through the Firestore map', () async {
      final cart = const Cart().add(chair, quantity: 3);
      final order = (await placeOrder(params(cart))).valueOrNull!;
      final map = OrderModel.toMap(order)
        ..['createdAt'] = '2030-05-01T12:00:00.000';
      final back = OrderModel.fromMap(order.id, map.cast<String, dynamic>());
      expect(back.total, order.total);
      expect(back.lines, order.lines);
      expect(back.address, address);
      expect(back.paymentMethod, PaymentMethod.cardOnDelivery);
      expect(back.createdAt, DateTime(2030, 5, 1, 12));
      expect(map['total'], order.total, reason: 'checked by security rules');
    });
  });

  group('delivery point', () {
    test('is saved with the order and read back', () async {
      const withPoint = ShippingAddress(
        fullName: 'Test Customer',
        phone: '+998 90 000 00 00',
        city: 'Tashkent',
        street: 'Test street 1',
        location: GeoPoint(41.311, 69.279),
      );
      final order = (await placeOrder(
        PlaceOrderParams(
          orderId: 'pointorder1',
          cart: const Cart().add(chair),
          delivery: DeliveryMethod.standard,
          address: withPoint,
          payment: PaymentMethod.cashOnDelivery,
          now: now,
        ),
      )).valueOrNull!;
      final map = OrderModel.toMap(order)
        ..['createdAt'] = '2030-05-01T12:00:00';
      final back = OrderModel.fromMap(order.id, map.cast<String, dynamic>());
      expect(back.address.location, const GeoPoint(41.311, 69.279));
      expect(orders.address!.location, isNotNull, reason: 'remembered');
    });

    test('impossible coordinates are ignored', () {
      final address = OrderModel.addressFromMap({
        'fullName': 'A',
        'phone': '1',
        'city': 'C',
        'street': 'S',
        'lat': 400,
        'lng': 69,
      });
      expect(address.location, isNull);
    });
  });

  group('OrdersCubit', () {
    test('loads, shows a just-placed order and cancels', () async {
      final cubit = OrdersCubit(
        getOrders: GetOrders(orders),
        cancelOrder: CancelOrder(orders),
      );
      await cubit.load();
      expect(cubit.state.orders, isEmpty);

      final order = (await placeOrder(
        params(const Cart().add(chair)),
      )).valueOrNull!;
      cubit.addPlaced(order);
      expect(cubit.state.orders.single.id, order.id);
      cubit.addPlaced(order);
      expect(cubit.state.orders, hasLength(1), reason: 'no duplicates');

      await cubit.cancel(order);
      expect(cubit.state.orders.single.status, OrderStatus.cancelled);
      expect(orders.orders.single.status, OrderStatus.cancelled);

      await cubit.cancel(cubit.state.orders.single);
      expect(
        cubit.state.failure,
        isA<ValidationFailure>(),
        reason: 'already cancelled',
      );
      await cubit.close();
    });
  });

  group('CheckoutCubit', () {
    test(
      'uses one order id per checkout, so a retry cannot duplicate',
      () async {
        final ids = _FixedIds();
        final cubit = CheckoutCubit(
          placeOrder: placeOrder,
          getSavedAddress: GetSavedAddress(orders),
          idGenerator: ids,
          clock: () => now,
        );
        orders.placeFailure = const NetworkFailure();
        await cubit.placeOrder(cart: const Cart().add(chair), address: address);
        expect(cubit.state.failure, const NetworkFailure());
        expect(cubit.state.placing, isFalse);

        orders.placeFailure = null;
        cubit.setDelivery(DeliveryMethod.express);
        cubit.setPayment(PaymentMethod.cardOnDelivery);
        await cubit.placeOrder(cart: const Cart().add(chair), address: address);
        final placed = cubit.state.placedOrder!;
        expect(placed.id, 'order1abcdef');
        expect(ids.calls, 1);
        expect(
          placed.delivery,
          Cart.standardDeliveryFee + Cart.expressSurcharge,
        );
        expect(placed.createdAt, now);

        // A second tap after success does nothing.
        await cubit.placeOrder(cart: const Cart().add(chair), address: address);
        expect(orders.orders, hasLength(1));
        await cubit.close();
      },
    );

    test('pre-fills the address used last time', () async {
      orders.address = address;
      final cubit = CheckoutCubit(
        placeOrder: placeOrder,
        getSavedAddress: GetSavedAddress(orders),
        idGenerator: _FixedIds(),
      );
      await cubit.loadSavedAddress();
      expect(cubit.state.savedAddress, address);
      await cubit.close();
    });
  });
}
