import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:furniture_store/features/favorites/domain/repositories/favorites_repository.dart';

/// Loads the favorite products, newest first. Products that no longer exist
/// in the catalog are left out.
class GetFavorites implements UseCase<List<Product>, NoParams> {
  const GetFavorites(this._favorites, this._catalog);

  final FavoritesRepository _favorites;
  final CatalogRepository _catalog;

  @override
  Future<Result<List<Product>>> call(NoParams params) async {
    final List<String> ids;
    switch (await _favorites.getFavoriteIds()) {
      case Err(:final failure):
        return Err(failure);
      case Ok(:final value):
        ids = value;
    }
    if (ids.isEmpty) return const Ok([]);

    final List<Product> catalog;
    switch (await _catalog.getProducts()) {
      case Err(:final failure):
        return Err(failure);
      case Ok(:final value):
        catalog = value;
    }
    final byId = {for (final p in catalog) p.id: p};
    return Ok([for (final id in ids) ?byId[id]]);
  }
}
