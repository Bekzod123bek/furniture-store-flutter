import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';

/// Applies search, category, filters and sorting to an already loaded
/// catalog. Pure and synchronous, so results appear while the user types.
class FilterProducts {
  const FilterProducts();

  /// [categoryNames] are extra words the search matches for each category,
  /// for example the category names in the user's language.
  List<Product> call(
    List<Product> products,
    ProductFilter filter, {
    Map<ProductCategory, List<String>> categoryNames = const {},
  }) {
    final query = filter.query.trim().toLowerCase();
    final result = products.where((p) {
      if (filter.category != null && p.category != filter.category) {
        return false;
      }
      if (query.isNotEmpty &&
          !p.name.toLowerCase().contains(query) &&
          !p.material.toLowerCase().contains(query) &&
          !_categoryMatches(p.category, query, categoryNames)) {
        return false;
      }
      if (p.price < filter.minPrice) return false;
      if (filter.maxPrice != null && p.price > filter.maxPrice!) return false;
      if (filter.materials.isNotEmpty &&
          !filter.materials.contains(p.material)) {
        return false;
      }
      if (p.rating < filter.minRating) return false;
      if (filter.onlyDiscounted && p.discountPercent == 0) return false;
      return true;
    }).toList();

    result.sort(switch (filter.sort) {
      SortOption.popular => (a, b) => b.popularity.compareTo(a.popularity),
      SortOption.newest => (a, b) {
        final byNew = (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0);
        return byNew != 0 ? byNew : b.popularity.compareTo(a.popularity);
      },
      SortOption.priceAsc => (a, b) => a.price.compareTo(b.price),
      SortOption.priceDesc => (a, b) => b.price.compareTo(a.price),
      SortOption.rating => (a, b) => b.rating.compareTo(a.rating),
    });
    return result;
  }

  static bool _categoryMatches(
    ProductCategory category,
    String query,
    Map<ProductCategory, List<String>> names,
  ) => [
    category.name,
    ...?names[category],
  ].any((name) => name.toLowerCase().contains(query));
}
