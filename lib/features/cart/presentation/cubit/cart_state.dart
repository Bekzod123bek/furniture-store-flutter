import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';

class CartState extends Equatable {
  const CartState({
    this.status = LoadStatus.initial,
    this.cart = const Cart(),
    this.failure,
  });

  final LoadStatus status;
  final Cart cart;

  /// Set when loading or saving the cart failed.
  final Failure? failure;

  CartState copyWith({
    LoadStatus? status,
    Cart? cart,
    Failure? Function()? failure,
  }) => CartState(
    status: status ?? this.status,
    cart: cart ?? this.cart,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, cart, failure];
}
