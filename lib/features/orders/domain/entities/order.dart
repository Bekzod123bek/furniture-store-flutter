import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/orders/domain/entities/order_line.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.createdAt,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.address,
    required this.paymentMethod,
    this.status = OrderStatus.processing,
  });

  final String id;
  final DateTime createdAt;
  final List<OrderLine> lines;
  final int subtotal;
  final int discount;
  final int delivery;
  final ShippingAddress address;
  final PaymentMethod paymentMethod;
  final OrderStatus status;

  int get total => subtotal - discount + delivery;

  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  /// Short number shown to the customer, for example `FS-K3J9A2`.
  String get number =>
      'FS-${id.substring(0, id.length < 6 ? id.length : 6).toUpperCase()}';

  /// Orders can only be cancelled until they are shipped.
  bool get canCancel => status == OrderStatus.processing;

  Order copyWith({OrderStatus? status}) => Order(
    id: id,
    createdAt: createdAt,
    lines: lines,
    subtotal: subtotal,
    discount: discount,
    delivery: delivery,
    address: address,
    paymentMethod: paymentMethod,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [id, status];
}
