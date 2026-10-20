import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/product_repository.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.products = const [],
    this.category,
    this.loading = true,
  });

  final List<Product> products;
  final Category? category;
  final bool loading;

  @override
  List<Object?> get props => [products, category, loading];
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repository) : super(const CatalogState());

  final ProductRepository _repository;

  Future<void> load({Category? category}) async {
    emit(CatalogState(
        products: state.products, category: category, loading: true));
    final products = await _repository.getProducts(category: category);
    emit(CatalogState(products: products, category: category, loading: false));
  }
}
