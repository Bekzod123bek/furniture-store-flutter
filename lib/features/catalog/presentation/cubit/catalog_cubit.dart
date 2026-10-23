import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/domain/usecases/catalog_summary.dart';
import 'package:furniture_store/features/catalog/domain/usecases/filter_products.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_banners.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_products.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_related_products.dart';
import 'package:furniture_store/features/catalog/presentation/cubit/catalog_state.dart';

/// Loads the catalog once, then filters it in memory so search and sorting
/// react instantly.
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({
    required GetProducts getProducts,
    required GetBanners getBanners,
    required FilterProducts filterProducts,
    required GetRelatedProducts getRelatedProducts,
  }) : _getProducts = getProducts,
       _getBanners = getBanners,
       _filter = filterProducts,
       _related = getRelatedProducts,
       super(const CatalogState());

  final GetProducts _getProducts;
  final GetBanners _getBanners;
  final FilterProducts _filter;
  final GetRelatedProducts _related;

  /// Category names in the user's language, so "divan" finds sofas.
  Map<ProductCategory, List<String>> _categoryNames = const {};

  /// Loads (or reloads) products and banners. Banners are decoration, so a
  /// banner error does not fail the page.
  Future<void> load({bool forceRefresh = false}) async {
    // Keep showing the old list while refreshing.
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));

    final productsRequest = _getProducts(
      GetProductsParams(forceRefresh: forceRefresh),
    );
    final bannersRequest = _getBanners(const NoParams());
    final productsResult = await productsRequest;
    final bannersResult = await bannersRequest;
    if (isClosed) return;

    switch (productsResult) {
      case Err(:final failure):
        emit(
          state.copyWith(status: LoadStatus.failure, failure: () => failure),
        );
      case Ok(value: final products):
        emit(
          state.copyWith(
            status: LoadStatus.success,
            all: products,
            banners: bannersResult.valueOrNull ?? const [],
            summary: CatalogSummary(products),
            visible: _filterProducts(products, state.filter),
          ),
        );
    }
  }

  /// Other products from the same category as [product].
  List<Product> relatedTo(Product product) => _related(state.all, product);

  void search(String query) => applyFilter(state.filter.copyWith(query: query));

  void selectCategory(ProductCategory? category) =>
      applyFilter(state.filter.copyWith(category: () => category));

  void sortBy(SortOption sort) =>
      applyFilter(state.filter.copyWith(sort: sort));

  void applyFilter(ProductFilter filter) => emit(
    state.copyWith(filter: filter, visible: _filterProducts(state.all, filter)),
  );

  /// Sets the category names the search should also match.
  void setCategoryNames(Map<ProductCategory, List<String>> names) {
    _categoryNames = names;
    if (state.filter.query.isNotEmpty) applyFilter(state.filter);
  }

  List<Product> _filterProducts(List<Product> products, ProductFilter filter) =>
      _filter(products, filter, categoryNames: _categoryNames);
}
