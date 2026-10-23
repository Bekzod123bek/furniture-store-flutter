import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';

class OrdersState extends Equatable {
  const OrdersState({
    this.status = LoadStatus.initial,
    this.orders = const [],
    this.failure,
  });

  final LoadStatus status;

  /// Newest first.
  final List<Order> orders;
  final Failure? failure;

  OrdersState copyWith({
    LoadStatus? status,
    List<Order>? orders,
    Failure? Function()? failure,
  }) => OrdersState(
    status: status ?? this.status,
    orders: orders ?? this.orders,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, orders, failure];
}
