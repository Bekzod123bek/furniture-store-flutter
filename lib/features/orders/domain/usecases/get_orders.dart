import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';

class GetOrders implements UseCase<List<Order>, NoParams> {
  const GetOrders(this._repository);

  final OrdersRepository _repository;

  @override
  Future<Result<List<Order>>> call(NoParams params) => _repository.getOrders();
}
