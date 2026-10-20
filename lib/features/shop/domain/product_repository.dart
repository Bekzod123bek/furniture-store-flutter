import 'entities.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    ProductFilter filter = const ProductFilter(),
  });

  Product? findById(String id);

  List<Product> related(Product product, {int limit = 6});

  /// All materials used in the catalog, for the filter sheet.
  List<String> get materials;

  /// Highest price in the catalog, for the price slider.
  int get maxPrice;
}
