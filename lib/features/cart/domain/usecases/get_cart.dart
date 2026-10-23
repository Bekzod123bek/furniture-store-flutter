import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_item.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/entities/promo_codes.dart';
import 'package:furniture_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';

/// Loads the saved cart and matches each row with the current catalog.
/// Rows whose product no longer exists are dropped.
class GetCart implements UseCase<Cart, NoParams> {
  const GetCart(this._cartRepository, this._catalogRepository);

  final CartRepository _cartRepository;
  final CatalogRepository _catalogRepository;

  @override
  Future<Result<Cart>> call(NoParams params) async {
    final CartSnapshot snapshot;
    switch (await _cartRepository.getCart()) {
      case Err(:final failure):
        return Err(failure);
      case Ok(:final value):
        snapshot = value;
    }
    if (snapshot.lines.isEmpty) return const Ok(Cart());

    final List<Product> catalog;
    switch (await _catalogRepository.getProducts()) {
      case Err(:final failure):
        return Err(failure);
      case Ok(:final value):
        catalog = value;
    }
    final products = {for (final p in catalog) p.id: p};

    final items = <CartItem>[];
    for (final line in snapshot.lines) {
      final product = products[line.productId];
      if (product == null) continue;
      final color = product.colors.firstWhere(
        (c) => c.name == line.colorName,
        orElse: () => product.colors.first,
      );
      items.add(
        CartItem(
          product: product,
          color: color,
          quantity: line.quantity.clamp(1, Cart.maxQuantityPerLine),
        ),
      );
    }
    final code = snapshot.promoCode;
    final validCode =
        items.isNotEmpty && code != null && PromoCodes.isValid(code);
    return Ok(
      Cart(
        items: items,
        promoCode: validCode ? PromoCodes.normalize(code) : null,
      ),
    );
  }
}
