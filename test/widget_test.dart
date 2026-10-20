import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/theme/theme_cubit.dart';
import 'package:furniture_store/core/widgets/app_image.dart';
import 'package:furniture_store/core/widgets/skeleton.dart';
import 'package:furniture_store/features/auth/auth_cubit.dart';
import 'package:furniture_store/features/shop/data/mock_product_repository.dart';
import 'package:furniture_store/features/shop/data/prefs_shop_storage.dart';
import 'package:furniture_store/features/shop/domain/entities.dart';
import 'package:furniture_store/features/shop/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/shop/presentation/cubit/catalog_cubit.dart';
import 'package:furniture_store/features/shop/presentation/cubit/favorites_cubit.dart';
import 'package:furniture_store/features/shop/presentation/cubit/orders_cubit.dart';
import 'package:furniture_store/injection.dart';
import 'package:furniture_store/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

void main() {
  setUpAll(() {
    AppImage.useCache = false;
    Skeleton.animate = false;
  });

  final repo = MockProductRepository(delay: Duration.zero);
  final sofa = repo.findById('p1')!; // $899, 3 colors
  final chair = repo.findById('p8')!; // $120

  group('MockProductRepository', () {
    test('filters by category, price, material, rating and sale', () async {
      final lamps = await repo.getProducts(
        filter: const ProductFilter(category: Category.lamp),
      );
      expect(lamps, isNotEmpty);
      expect(lamps.every((p) => p.category == Category.lamp), isTrue);

      final cheapOak = await repo.getProducts(
        filter: const ProductFilter(maxPrice: 500, materials: {'Oak'}),
      );
      expect(
        cheapOak.every((p) => p.material == 'Oak' && p.price <= 500),
        isTrue,
      );
      expect(cheapOak, isNotEmpty);

      final sale = await repo.getProducts(
        filter: const ProductFilter(onlyDiscounted: true, minRating: 4.7),
      );
      expect(
        sale.every((p) => p.discountPercent > 0 && p.rating >= 4.7),
        isTrue,
      );
    });

    test('search matches name, material and category', () async {
      expect(
        (await repo.getProducts(
          filter: const ProductFilter(query: 'velvet'),
        )).every((p) => p.material == 'Velvet'),
        isTrue,
      );
      expect(
        await repo.getProducts(filter: const ProductFilter(query: 'zzz')),
        isEmpty,
      );
    });

    test('sorts by price', () async {
      final asc = await repo.getProducts(
        filter: const ProductFilter(sort: SortOption.priceAsc),
      );
      for (var i = 1; i < asc.length; i++) {
        expect(asc[i].price, greaterThanOrEqualTo(asc[i - 1].price));
      }
    });

    test('every product has photos, colors and reviews', () {
      for (final p in MockProductRepository.products) {
        expect(p.images, isNotEmpty, reason: p.name);
        expect(p.colors, isNotEmpty, reason: p.name);
        expect(p.reviews, isNotEmpty, reason: p.name);
      }
      expect(sofa.discountPercent, 18);
    });
  });

  group('CartCubit', () {
    test(
      'merges same product and color, keeps other colors separate',
      () async {
        final cart = CartCubit(repo, PrefsShopStorage(await _prefs()));
        await cart.add(sofa);
        await cart.add(sofa, quantity: 2);
        await cart.add(sofa, color: sofa.colors[1]);
        expect(cart.state.items, hasLength(2));
        expect(cart.state.count, 4);
        expect(cart.state.subtotal, 899 * 4);
      },
    );

    test('promo code, delivery fee and free delivery threshold', () async {
      final cart = CartCubit(repo, PrefsShopStorage(await _prefs()));
      await cart.add(chair); // $120
      expect(cart.state.delivery, standardDeliveryFee);
      expect(cart.applyPromo('nope'), isFalse);
      expect(cart.applyPromo(' sale10 '), isTrue);
      expect(cart.state.discount, 12);
      expect(cart.state.total, 120 - 12 + standardDeliveryFee);

      await cart.add(sofa, quantity: 2); // subtotal 1918
      expect(cart.state.delivery, 0);

      await cart.clear();
      expect(cart.state.promoCode, isNull);
      expect(cart.state.total, 0);
    });

    test('is restored from storage', () async {
      final storage = PrefsShopStorage(await _prefs());
      final cart = CartCubit(repo, storage);
      await cart.add(sofa, color: sofa.colors[2], quantity: 3);

      final restored = CartCubit(repo, storage);
      expect(restored.state.items.single.color.name, sofa.colors[2].name);
      expect(restored.state.count, 3);

      await restored.setQuantity(restored.state.items.single, 0);
      expect(CartCubit(repo, storage).state.items, isEmpty);
    });
  });

  test('FavoritesCubit toggles and persists', () async {
    final storage = PrefsShopStorage(await _prefs());
    final favorites = FavoritesCubit(repo, storage);
    expect(await favorites.toggle(sofa), isTrue);
    expect(FavoritesCubit(repo, storage).state, [sofa]);
    expect(await favorites.toggle(sofa), isFalse);
    expect(FavoritesCubit(repo, storage).state, isEmpty);
  });

  test('OrdersCubit stores orders newest first', () async {
    final storage = PrefsShopStorage(await _prefs());
    final cart = CartCubit(repo, storage);
    await cart.add(chair, quantity: 2);
    cart.applyPromo('WELCOME20');

    final orders = OrdersCubit(storage);
    final order = await orders.place(
      cart: cart.state,
      delivery: 25,
      address: 'Tashkent',
      paymentMethod: 'Cash on delivery',
      now: DateTime(2030, 5, 1),
    );
    expect(order.total, 240 - 48 + 25);
    expect(order.itemCount, 2);

    final reloaded = OrdersCubit(storage).state.single;
    expect(reloaded.id, order.id);
    expect(reloaded.total, order.total);
    expect(reloaded.lines.single.name, chair.name);
  });

  test('CatalogCubit applies category and sort', () async {
    final catalog = CatalogCubit(repo);
    await catalog.selectCategory(Category.bed);
    expect(
      catalog.state.products.every((p) => p.category == Category.bed),
      isTrue,
    );
    await catalog.sortBy(SortOption.priceDesc);
    expect(
      catalog.state.products.first.price,
      greaterThanOrEqualTo(catalog.state.products.last.price),
    );
    expect(catalog.state.loading, isFalse);
  });

  test(
    'AuthCubit: onboarding -> sign in -> sign out, no password stored',
    () async {
      final prefs = await _prefs();
      final auth = AuthCubit(prefs, delay: Duration.zero);
      expect(auth.state.status, AuthStatus.onboarding);
      await auth.finishOnboarding();
      expect(auth.state.status, AuthStatus.signedOut);

      await auth.signIn(
        email: 'bekzod@example.com',
        name: 'Bekzod Abdurahimov',
      );
      expect(auth.state.initials, 'BA');
      expect(AuthCubit(prefs).state.status, AuthStatus.signedIn);
      expect(prefs.getKeys().any((k) => k.contains('password')), isFalse);

      await auth.signOut();
      expect(AuthCubit(prefs).state.status, AuthStatus.signedOut);
    },
  );

  test('ThemeCubit remembers dark mode', () async {
    final prefs = await _prefs();
    await ThemeCubit(prefs).toggle(Brightness.light);
    expect(ThemeCubit(prefs).state, ThemeMode.dark);
  });

  group('App', () {
    testWidgets('onboarding, sign in, home, product and cart', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await setupDependencies(fast: true);
      await tester.pumpWidget(const FurnitureStoreApp());
      await tester.pumpAndSettle();

      expect(find.text('Furniture that feels like home'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'bekzod@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret1',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Find furniture you love'), findsOneWidget);
      expect(find.text('Emerald Velvet Sofa'), findsOneWidget);

      await tester.ensureVisible(find.text('Emerald Velvet Sofa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Emerald Velvet Sofa'));
      await tester.pumpAndSettle();
      expect(find.text('About'), findsOneWidget);

      await tester.tap(find.textContaining('Add ·'));
      await tester.pumpAndSettle();
      expect(find.textContaining('added to cart'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Checkout ·'), findsOneWidget);

      // Unmount so the banner timer is cancelled.
      await tester.pumpWidget(const SizedBox());
    });
  });
}
