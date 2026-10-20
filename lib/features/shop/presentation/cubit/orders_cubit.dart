import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/shop_storage.dart';
import 'cart_cubit.dart';

class OrdersCubit extends Cubit<List<Order>> {
  OrdersCubit(this._storage)
    : super([for (final json in _storage.loadOrders()) Order.fromJson(json)]);

  final ShopStorage _storage;

  Future<Order> place({
    required CartState cart,
    required int delivery,
    required String address,
    required String paymentMethod,
    DateTime? now,
  }) async {
    final date = now ?? DateTime.now();
    final order = Order(
      id: 'FS-${date.millisecondsSinceEpoch % 1000000}',
      date: date,
      lines: [
        for (final i in cart.items)
          OrderLine(
            productId: i.product.id,
            name: i.product.name,
            image: i.product.images.first,
            color: i.color.name,
            quantity: i.quantity,
            price: i.product.price,
          ),
      ],
      subtotal: cart.subtotal,
      discount: cart.discount,
      delivery: delivery,
      address: address,
      paymentMethod: paymentMethod,
    );
    final updated = [order, ...state];
    emit(updated);
    await _storage.saveOrders([for (final o in updated) o.toJson()]);
    return order;
  }
}
