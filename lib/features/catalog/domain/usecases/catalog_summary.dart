import 'package:furniture_store/features/catalog/domain/entities/product.dart';

/// Values the filter sheet needs, derived from the loaded catalog.
class CatalogSummary {
  CatalogSummary(List<Product> products)
    : materials = (products.map((p) => p.material).toSet().toList()..sort()),
      maxPrice = products.isEmpty
          ? 0
          : products.map((p) => p.price).reduce((a, b) => a > b ? a : b);

  final List<String> materials;
  final int maxPrice;
}
