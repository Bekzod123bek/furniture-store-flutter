import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/repositories/cart_repository.dart';

class SaveCart implements UseCase<void, Cart> {
  const SaveCart(this._repository);

  final CartRepository _repository;

  @override
  Future<Result<void>> call(Cart params) => _repository.saveCart(
    CartSnapshot(lines: params.toLines(), promoCode: params.promoCode),
  );
}
