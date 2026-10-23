import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    this.delivery = DeliveryMethod.standard,
    this.payment = PaymentMethod.cashOnDelivery,
    this.savedAddress,
    this.placing = false,
    this.placedOrder,
    this.failure,
  });

  final DeliveryMethod delivery;
  final PaymentMethod payment;

  /// The address used last time, to pre-fill the form.
  final ShippingAddress? savedAddress;
  final bool placing;

  /// Set once the order was placed.
  final Order? placedOrder;
  final Failure? failure;

  CheckoutState copyWith({
    DeliveryMethod? delivery,
    PaymentMethod? payment,
    ShippingAddress? savedAddress,
    bool? placing,
    Order? placedOrder,
    Failure? Function()? failure,
  }) => CheckoutState(
    delivery: delivery ?? this.delivery,
    payment: payment ?? this.payment,
    savedAddress: savedAddress ?? this.savedAddress,
    placing: placing ?? this.placing,
    placedOrder: placedOrder ?? this.placedOrder,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    delivery,
    payment,
    savedAddress,
    placing,
    placedOrder,
    failure,
  ];
}
