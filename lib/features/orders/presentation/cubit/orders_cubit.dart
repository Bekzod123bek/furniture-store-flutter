import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/usecases/cancel_order.dart';
import 'package:furniture_store/features/orders/domain/usecases/get_orders.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required GetOrders getOrders, required CancelOrder cancelOrder})
    : _get = getOrders,
      _cancel = cancelOrder,
      super(const OrdersState());

  final GetOrders _get;
  final CancelOrder _cancel;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));
    final result = await _get(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(status: LoadStatus.success, orders: value));
      case Err(:final failure):
        emit(
          state.copyWith(status: LoadStatus.failure, failure: () => failure),
        );
    }
  }

  /// Shows a just-placed order at the top without reloading the list.
  void addPlaced(Order order) => emit(
    state.copyWith(
      status: LoadStatus.success,
      orders: [order, ...state.orders.where((o) => o.id != order.id)],
    ),
  );

  /// Cancels an order that is still being processed.
  Future<void> cancel(Order order) async {
    final result = await _cancel(order);
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(
          state.copyWith(
            orders: [
              for (final o in state.orders)
                o.id == order.id
                    ? o.copyWith(status: OrderStatus.cancelled)
                    : o,
            ],
            failure: () => null,
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(failure: () => failure));
    }
  }
}
