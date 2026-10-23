import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_line.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/usecases/get_cart.dart';
import 'package:furniture_store/features/cart/domain/usecases/save_cart.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';

import '../helpers/fakes.dart';
import '../helpers/seed_catalog.dart';

void main() {
  final products = SeedCatalog.products();
  final sofa = SeedCatalog.byId('p1');
  final chair = SeedCatalog.byId('p8');

  late FakeCatalogRepository catalog;
  late FakeCartRepository storage;

  CartCubit newCubit() => CartCubit(
    getCart: GetCart(storage, catalog),
    saveCart: SaveCart(storage),
  );

  setUp(() {
    catalog = FakeCatalogRepository(products);
    storage = FakeCartRepository();
  });

  group('GetCart', () {
    test(
      'matches saved rows with the catalog and drops unknown products',
      () async {
        storage.saved = const CartSnapshot(
          lines: [
            CartLine(productId: 'p1', colorName: 'Rose', quantity: 3),
            CartLine(productId: 'gone', colorName: 'Red', quantity: 1),
            CartLine(
              productId: 'p8',
              colorName: 'Unknown colour',
              quantity: 99,
            ),
          ],
          promoCode: 'welcome20',
        );
        final cart = (await GetCart(storage, catalog)(
          const NoParams(),
        )).valueOrNull!;
        expect(cart.items, hasLength(2));
        expect(cart.items.first.color.name, 'Rose');
        expect(cart.items.last.color, chair.colors.first, reason: 'falls back');
        expect(cart.items.last.quantity, 10, reason: 'capped');
        expect(cart.promoCode, 'WELCOME20');
      },
    );

    test(
      'forgets a promo code that is no longer valid or has no items',
      () async {
        storage.saved = const CartSnapshot(promoCode: 'SALE10');
        expect(
          (await GetCart(storage, catalog)(
            const NoParams(),
          )).valueOrNull!.promoCode,
          isNull,
        );
        storage.saved = const CartSnapshot(
          lines: [CartLine(productId: 'p1', colorName: 'Navy', quantity: 1)],
          promoCode: 'OLDCODE',
        );
        expect(
          (await GetCart(storage, catalog)(
            const NoParams(),
          )).valueOrNull!.promoCode,
          isNull,
        );
      },
    );

    test('passes storage and catalog failures through', () async {
      storage.failure = const NetworkFailure();
      expect(
        (await GetCart(storage, catalog)(const NoParams())).failureOrNull,
        const NetworkFailure(),
      );
      storage.failure = null;
      storage.saved = const CartSnapshot(
        lines: [CartLine(productId: 'p1', colorName: 'Navy', quantity: 1)],
      );
      catalog.failure = const ServerFailure();
      expect(
        (await GetCart(storage, catalog)(const NoParams())).failureOrNull,
        const ServerFailure(),
      );
    });
  });

  group('CartCubit', () {
    test('changes are applied at once and saved', () async {
      final cubit = newCubit();
      await cubit.load();
      expect(cubit.state.status, LoadStatus.success);

      await cubit.add(sofa, color: sofa.colors[1], quantity: 2);
      expect(cubit.state.cart.count, 2);
      expect(storage.saved.lines.single.colorName, sofa.colors[1].name);

      await cubit.setQuantity(cubit.state.cart.items.single, 4);
      expect(storage.saved.lines.single.quantity, 4);

      await cubit.remove(cubit.state.cart.items.single);
      expect(cubit.state.cart.isEmpty, isTrue);
      expect(storage.saved.lines, isEmpty);
      await cubit.close();
    });

    test('addAll saves once', () async {
      final cubit = newCubit();
      await cubit.load();
      storage.saves = 0;
      await cubit.addAll([
        CartAddition(sofa),
        CartAddition(chair, quantity: 4),
      ]);
      expect(cubit.state.cart.count, 5);
      expect(storage.saves, 1);
      await cubit.close();
    });

    test('promo code is saved and restored with the cart', () async {
      final cubit = newCubit();
      await cubit.load();
      await cubit.add(chair);
      expect(cubit.applyPromo('nope'), isFalse);
      expect(cubit.applyPromo('SALE10'), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(storage.saved.promoCode, 'SALE10');

      final restored = newCubit();
      await restored.load();
      expect(restored.state.cart.promoCode, 'SALE10');
      expect(restored.state.cart.count, 1);
      await cubit.close();
      await restored.close();
    });

    test(
      'a failed save keeps the change on screen and reports the failure',
      () async {
        final cubit = newCubit();
        await cubit.load();
        storage.failure = const NetworkFailure();
        await cubit.add(chair);
        expect(cubit.state.cart.count, 1);
        expect(cubit.state.failure, const NetworkFailure());
        await cubit.close();
      },
    );

    test('a failed load is reported', () async {
      storage.failure = const NetworkFailure();
      final cubit = newCubit();
      await cubit.load();
      expect(cubit.state.status, LoadStatus.failure);
      await cubit.close();
    });
  });
}
