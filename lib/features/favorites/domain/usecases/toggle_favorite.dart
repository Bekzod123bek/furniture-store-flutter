import 'package:furniture_store/features/catalog/domain/entities/product.dart';

/// Adds [product] to the front of [favorites], or removes it if present.
class ToggleFavorite {
  const ToggleFavorite();

  List<Product> call(List<Product> favorites, Product product) =>
      favorites.contains(product)
      ? favorites.where((p) => p != product).toList()
      : [product, ...favorites];
}
