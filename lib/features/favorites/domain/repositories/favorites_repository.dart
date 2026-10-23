import 'package:furniture_store/core/result/result.dart';

abstract interface class FavoritesRepository {
  /// Favorite product ids, newest first.
  Future<Result<List<String>>> getFavoriteIds();
  Future<Result<void>> saveFavoriteIds(List<String> ids);
}
