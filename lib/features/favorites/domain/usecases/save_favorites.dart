import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/favorites/domain/repositories/favorites_repository.dart';

class SaveFavorites implements UseCase<void, List<Product>> {
  const SaveFavorites(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Result<void>> call(List<Product> params) =>
      _repository.saveFavoriteIds([for (final p in params) p.id]);
}
