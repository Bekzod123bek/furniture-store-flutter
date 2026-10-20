import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/shop/data/mock_product_repository.dart';
import 'package:furniture_store/features/shop/domain/entities.dart';
import 'package:furniture_store/features/shop/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/injection.dart';
import 'package:furniture_store/main.dart';

void main() {
  test('cart adds, increases and removes items', () async {
    final products = await MockProductRepository().getProducts();
    final cart = CartCubit();

    cart.add(products.first);
    cart.add(products.first);
    expect(cart.count, 2);
    expect(cart.total, products.first.price * 2);

    cart.decrease(products.first);
    cart.decrease(products.first);
    expect(cart.state, isEmpty);
  });

  test('catalog filters by category', () async {
    final chairs =
        await MockProductRepository().getProducts(category: Category.chair);
    expect(chairs, isNotEmpty);
    expect(chairs.every((p) => p.category == Category.chair), isTrue);
  });

  testWidgets('app shows the catalog', (tester) async {
    await setupDependencies();
    await tester.pumpWidget(const FurnitureStoreApp());
    await tester.pumpAndSettle();
    expect(find.text('Nordic 3-seat sofa'), findsOneWidget);
  });
}
