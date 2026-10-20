import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/product_repository.dart';
import '../../domain/shop_storage.dart';

class FavoritesCubit extends Cubit<List<Product>> {
  FavoritesCubit(this._repository, this._storage)
    : super([
        for (final id in _storage.loadFavorites()) ?_repository.findById(id),
      ]);

  final ProductRepository _repository;
  final ShopStorage _storage;

  bool isFavorite(Product product) => state.contains(product);

  /// Returns `true` when the product was added.
  Future<bool> toggle(Product product) async {
    final added = !isFavorite(product);
    final updated = added
        ? [product, ...state]
        : state.where((p) => p != product).toList();
    emit(updated);
    await _storage.saveFavorites([for (final p in updated) p.id]);
    return added;
  }

  Product? find(String id) => _repository.findById(id);
}
