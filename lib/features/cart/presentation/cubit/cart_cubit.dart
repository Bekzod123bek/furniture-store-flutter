import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_item.dart';
import 'package:furniture_store/features/cart/domain/usecases/get_cart.dart';
import 'package:furniture_store/features/cart/domain/usecases/save_cart.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_state.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';

/// A product to put in the cart.
class CartAddition {
  const CartAddition(this.product, {this.color, this.quantity = 1});

  final Product product;
  final ProductColor? color;
  final int quantity;
}

/// Every change is applied to the screen first and then saved, so the cart
/// feels instant even on a slow connection.
class CartCubit extends Cubit<CartState> {
  CartCubit({required GetCart getCart, required SaveCart saveCart})
    : _get = getCart,
      _save = saveCart,
      super(const CartState());

  final GetCart _get;
  final SaveCart _save;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));
    final result = await _get(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(status: LoadStatus.success, cart: value));
      case Err(:final failure):
        emit(
          state.copyWith(status: LoadStatus.failure, failure: () => failure),
        );
    }
  }

  Future<void> add(Product product, {ProductColor? color, int quantity = 1}) =>
      addAll([CartAddition(product, color: color, quantity: quantity)]);

  /// Adds several products with a single save.
  Future<void> addAll(List<CartAddition> additions) {
    var cart = state.cart;
    for (final a in additions) {
      cart = cart.add(a.product, color: a.color, quantity: a.quantity);
    }
    return _apply(cart);
  }

  Future<void> setQuantity(CartItem item, int quantity) =>
      _apply(state.cart.setQuantity(item, quantity));

  Future<void> remove(CartItem item) => _apply(state.cart.remove(item));

  /// Returns `true` when [code] is a valid promo code.
  bool applyPromo(String code) {
    final next = state.cart.applyPromo(code);
    if (next == null) return false;
    _apply(next);
    return true;
  }

  Future<void> removePromo() => _apply(state.cart.removePromo());

  Future<void> clear() => _apply(const Cart());

  Future<void> _apply(Cart next) async {
    emit(state.copyWith(cart: next, failure: () => null));
    final result = await _save(next);
    if (isClosed) return;
    if (result case Err(:final failure)) {
      emit(state.copyWith(failure: () => failure));
    }
  }
}
