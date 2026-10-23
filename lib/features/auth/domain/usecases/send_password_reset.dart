import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordReset implements UseCase<void, String> {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String params) =>
      _repository.sendPasswordReset(params.trim());
}
