import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';

class CancelOrder implements UseCase<void, Order> {
  const CancelOrder(this._repository);

  final OrdersRepository _repository;

  @override
  Future<Result<void>> call(Order params) {
    if (!params.canCancel) {
      return Future.value(
        const Err(ValidationFailure(ValidationIssue.orderNotCancellable)),
      );
    }
    return _repository.cancelOrder(params.id);
  }
}
