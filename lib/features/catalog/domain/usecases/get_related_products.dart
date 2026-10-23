import 'package:furniture_store/features/catalog/domain/entities/product.dart';

/// Other products from the same category, most popular first.
class GetRelatedProducts {
  const GetRelatedProducts();

  List<Product> call(List<Product> all, Product product, {int limit = 6}) {
    final related =
        all
            .where((p) => p.category == product.category && p != product)
            .toList()
          ..sort((a, b) => b.popularity.compareTo(a.popularity));
    return related.take(limit).toList();
  }
}
