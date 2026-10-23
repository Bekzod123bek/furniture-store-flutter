import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this._remote);

  final OrdersRemoteDataSource _remote;

  @override
  Future<Result<List<Order>>> getOrders() => guard(_remote.fetchOrders);

  @override
  Future<Result<void>> placeOrder(Order order) =>
      guard(() => _remote.createOrder(order));

  @override
  Future<Result<void>> cancelOrder(String orderId) =>
      guard(() => _remote.setCancelled(orderId));

  @override
  Future<Result<ShippingAddress?>> getSavedAddress() =>
      guard(_remote.fetchAddress);

  @override
  Future<Result<void>> saveAddress(ShippingAddress address) =>
      guard(() => _remote.writeAddress(address));
}
