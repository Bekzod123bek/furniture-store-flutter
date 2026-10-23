import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';

class GetSavedAddress implements UseCase<ShippingAddress?, NoParams> {
  const GetSavedAddress(this._repository);

  final OrdersRepository _repository;

  @override
  Future<Result<ShippingAddress?>> call(NoParams params) =>
      _repository.getSavedAddress();
}
