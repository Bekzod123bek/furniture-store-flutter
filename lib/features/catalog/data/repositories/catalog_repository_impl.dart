import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._remote);

  final CatalogRemoteDataSource _remote;

  List<Product>? _products;
  List<PromoBanner>? _banners;

  @override
  Future<Result<List<Product>>> getProducts({bool forceRefresh = false}) {
    final cached = _products;
    if (cached != null && !forceRefresh) return Future.value(Ok(cached));
    return guard(() async => _products = await _remote.fetchProducts());
  }

  @override
  Future<Result<List<PromoBanner>>> getBanners() {
    final cached = _banners;
    if (cached != null) return Future.value(Ok(cached));
    return guard(() async => _banners = await _remote.fetchBanners());
  }
}
