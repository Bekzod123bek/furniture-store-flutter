import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.signOut();
}
