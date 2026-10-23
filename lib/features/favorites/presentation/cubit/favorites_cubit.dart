import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/favorites/domain/usecases/get_favorites.dart';
import 'package:furniture_store/features/favorites/domain/usecases/save_favorites.dart';
import 'package:furniture_store/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required GetFavorites getFavorites,
    required SaveFavorites saveFavorites,
    required ToggleFavorite toggleFavorite,
  }) : _get = getFavorites,
       _save = saveFavorites,
       _toggle = toggleFavorite,
       super(const FavoritesState());

  final GetFavorites _get;
  final SaveFavorites _save;
  final ToggleFavorite _toggle;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));
    final result = await _get(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(status: LoadStatus.success, products: value));
      case Err(:final failure):
        emit(
          state.copyWith(status: LoadStatus.failure, failure: () => failure),
        );
    }
  }

  /// Adds or removes [product]. The heart changes at once; if saving fails
  /// the change is undone and [FavoritesState.failure] is set.
  /// Returns `true` when the product was added.
  Future<bool> toggle(Product product) async {
    final before = state.products;
    final after = _toggle(before, product);
    emit(state.copyWith(products: after, failure: () => null));

    final result = await _save(after);
    if (isClosed) return after.contains(product);
    if (result case Err(:final failure)) {
      emit(state.copyWith(products: before, failure: () => failure));
      return before.contains(product);
    }
    return after.contains(product);
  }
}
