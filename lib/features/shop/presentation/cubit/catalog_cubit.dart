import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/product_repository.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.products = const [],
    this.filter = const ProductFilter(),
    this.loading = true,
  });

  final List<Product> products;
  final ProductFilter filter;
  final bool loading;

  CatalogState copyWith({
    List<Product>? products,
    ProductFilter? filter,
    bool? loading,
  }) => CatalogState(
    products: products ?? this.products,
    filter: filter ?? this.filter,
    loading: loading ?? this.loading,
  );

  @override
  List<Object?> get props => [products, filter, loading];
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repository) : super(const CatalogState());

  final ProductRepository _repository;

  Future<void> load() => applyFilter(state.filter);

  Future<void> search(String query) =>
      applyFilter(state.filter.copyWith(query: query));

  Future<void> selectCategory(Category? category) =>
      applyFilter(state.filter.copyWith(category: () => category));

  Future<void> sortBy(SortOption sort) =>
      applyFilter(state.filter.copyWith(sort: sort));

  Future<void> applyFilter(ProductFilter filter) async {
    emit(state.copyWith(filter: filter, loading: true));
    final products = await _repository.getProducts(filter: filter);
    // Drop results of an outdated request.
    if (isClosed || filter != state.filter) return;
    emit(state.copyWith(products: products, loading: false));
  }
}
