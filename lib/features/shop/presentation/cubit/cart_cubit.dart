import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/product_repository.dart';
import '../../domain/shop_storage.dart';

/// Demo promo codes and their discount rates.
const promoCodes = {'SALE10': 0.10, 'WELCOME20': 0.20};

/// Orders at or above this subtotal get free standard delivery.
const freeDeliveryFrom = 1000;
const standardDeliveryFee = 25;

class CartState extends Equatable {
  const CartState({this.items = const [], this.promoCode});

  final List<CartItem> items;
  final String? promoCode;

  int get count => items.fold(0, (sum, i) => sum + i.quantity);
  int get subtotal => items.fold(0, (sum, i) => sum + i.subtotal);
  int get discount =>
      promoCode == null ? 0 : (subtotal * promoCodes[promoCode]!).round();
  int get delivery =>
      items.isEmpty || subtotal >= freeDeliveryFrom ? 0 : standardDeliveryFee;
  int get total => subtotal - discount + delivery;

  CartState copyWith({List<CartItem>? items, String? Function()? promoCode}) =>
      CartState(
        items: items ?? this.items,
        promoCode: promoCode != null ? promoCode() : this.promoCode,
      );

  @override
  List<Object?> get props => [items, promoCode];
}

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository, this._storage)
    : super(CartState(items: _restore(_repository, _storage)));

  final ProductRepository _repository;
  final ShopStorage _storage;

  static List<CartItem> _restore(ProductRepository repo, ShopStorage storage) {
    final items = <CartItem>[];
    for (final json in storage.loadCart()) {
      final product = repo.findById(json['productId'] as String);
      if (product == null) continue;
      final color = product.colors.firstWhere(
        (c) => c.name == json['color'],
        orElse: () => product.colors.first,
      );
      items.add(
        CartItem(
          product: product,
          color: color,
          quantity: json['quantity'] as int,
        ),
      );
    }
    return items;
  }

  Future<void> add(Product product, {ProductColor? color, int quantity = 1}) {
    final line = CartItem(
      product: product,
      color: color ?? product.colors.first,
      quantity: quantity,
    );
    final index = state.items.indexWhere(line.sameLine);
    final items = [...state.items];
    if (index == -1) {
      items.add(line);
    } else {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    }
    return _save(state.copyWith(items: items));
  }

  Future<void> setQuantity(CartItem item, int quantity) {
    final items = [
      for (final i in state.items)
        if (!i.sameLine(item))
          i
        else if (quantity > 0)
          i.copyWith(quantity: quantity),
    ];
    return _save(state.copyWith(items: items));
  }

  Future<void> remove(CartItem item) => setQuantity(item, 0);

  /// Returns `true` when the code is valid.
  bool applyPromo(String code) {
    final normalized = code.trim().toUpperCase();
    if (!promoCodes.containsKey(normalized)) return false;
    emit(state.copyWith(promoCode: () => normalized));
    return true;
  }

  void removePromo() => emit(state.copyWith(promoCode: () => null));

  Future<void> clear() => _save(const CartState());

  Future<void> _save(CartState next) async {
    final cleared = next.items.isEmpty;
    emit(cleared ? next.copyWith(promoCode: () => null) : next);
    await _storage.saveCart([for (final i in next.items) i.toJson()]);
  }

  Product? find(String id) => _repository.findById(id);
}
