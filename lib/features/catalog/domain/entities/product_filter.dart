import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';

enum SortOption { popular, newest, priceAsc, priceDesc, rating }

class ProductFilter extends Equatable {
  const ProductFilter({
    this.query = '',
    this.category,
    this.minPrice = 0,
    this.maxPrice,
    this.materials = const {},
    this.minRating = 0,
    this.onlyDiscounted = false,
    this.sort = SortOption.popular,
  });

  final String query;
  final ProductCategory? category;
  final int minPrice;

  /// `null` means no upper limit.
  final int? maxPrice;
  final Set<String> materials;
  final double minRating;
  final bool onlyDiscounted;
  final SortOption sort;

  /// Number of filters set in the filter sheet (search and category excluded).
  int get activeCount =>
      (minPrice > 0 || maxPrice != null ? 1 : 0) +
      (materials.isNotEmpty ? 1 : 0) +
      (minRating > 0 ? 1 : 0) +
      (onlyDiscounted ? 1 : 0);

  /// Whether the user is just browsing: no search, category or filters.
  bool get isBrowsing =>
      query.trim().isEmpty && category == null && activeCount == 0;

  ProductFilter copyWith({
    String? query,
    ProductCategory? Function()? category,
    int? minPrice,
    int? Function()? maxPrice,
    Set<String>? materials,
    double? minRating,
    bool? onlyDiscounted,
    SortOption? sort,
  }) => ProductFilter(
    query: query ?? this.query,
    category: category != null ? category() : this.category,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
    materials: materials ?? this.materials,
    minRating: minRating ?? this.minRating,
    onlyDiscounted: onlyDiscounted ?? this.onlyDiscounted,
    sort: sort ?? this.sort,
  );

  /// Clears the filter sheet values but keeps search, category and sort.
  ProductFilter resetSheet() =>
      ProductFilter(query: query, category: category, sort: sort);

  @override
  List<Object?> get props => [
    query,
    category,
    minPrice,
    maxPrice,
    materials,
    minRating,
    onlyDiscounted,
    sort,
  ];
}
