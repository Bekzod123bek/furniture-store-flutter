import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';

abstract interface class OrdersRepository {
  /// The user's orders, newest first.
  Future<Result<List<Order>>> getOrders();

  /// Saves [order]. Placing the same order id twice is safe.
  Future<Result<void>> placeOrder(Order order);

  Future<Result<void>> cancelOrder(String orderId);

  /// The delivery address used last time, or `null`.
  Future<Result<ShippingAddress?>> getSavedAddress();

  Future<Result<void>> saveAddress(ShippingAddress address);
}
