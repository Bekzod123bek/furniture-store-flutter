import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';

abstract interface class CatalogRepository {
  /// All products. The list is cached after the first successful load; pass
  /// [forceRefresh] to fetch it again.
  Future<Result<List<Product>>> getProducts({bool forceRefresh = false});

  Future<Result<List<PromoBanner>>> getBanners();
}
