import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';

class GetProducts implements UseCase<List<Product>, GetProductsParams> {
  const GetProducts(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<Product>>> call(GetProductsParams params) =>
      _repository.getProducts(forceRefresh: params.forceRefresh);
}

class GetProductsParams {
  const GetProductsParams({this.forceRefresh = false});

  final bool forceRefresh;
}
