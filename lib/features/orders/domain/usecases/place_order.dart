import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/order_line.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';

class PlaceOrderParams {
  const PlaceOrderParams({
    required this.orderId,
    required this.cart,
    required this.delivery,
    required this.address,
    required this.payment,
    required this.now,
  });

  /// Created once per checkout. Retrying with the same id can never create
  /// a second order.
  final String orderId;
  final Cart cart;
  final DeliveryMethod delivery;
  final ShippingAddress address;
  final PaymentMethod payment;
  final DateTime now;
}

/// Turns the cart into an order, then empties the cart and remembers the
/// address for next time.
class PlaceOrder implements UseCase<Order, PlaceOrderParams> {
  const PlaceOrder(this._orders, this._cart);

  final OrdersRepository _orders;
  final CartRepository _cart;

  @override
  Future<Result<Order>> call(PlaceOrderParams params) async {
    final cart = params.cart;
    if (cart.isEmpty) {
      return const Err(ValidationFailure(ValidationIssue.emptyCart));
    }
    if (!params.address.isComplete) {
      return const Err(ValidationFailure(ValidationIssue.incompleteAddress));
    }

    final order = Order(
      id: params.orderId,
      createdAt: params.now,
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
      delivery: cart.deliveryFee(params.delivery),
      address: params.address,
      paymentMethod: params.payment,
    );

    final placed = await _orders.placeOrder(order);
    if (placed case Err(:final failure)) return Err(failure);

    // The order exists now. Failing to tidy up must not fail the checkout.
    final cleared = await _cart.saveCart(const CartSnapshot());
    if (cleared case Err(:final failure)) {
      AppLogger.info('Cart not cleared after order: ${failure.message}');
    }
    final saved = await _orders.saveAddress(params.address);
    if (saved case Err(:final failure)) {
      AppLogger.info('Address not saved: ${failure.message}');
    }
    return Ok(order);
  }
}
