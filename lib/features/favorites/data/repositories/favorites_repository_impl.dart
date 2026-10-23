import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:furniture_store/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._remote);

  final FavoritesRemoteDataSource _remote;

  @override
  Future<Result<List<String>>> getFavoriteIds() => guard(_remote.fetchIds);

  @override
  Future<Result<void>> saveFavoriteIds(List<String> ids) =>
      guard(() => _remote.writeIds(ids));
}
