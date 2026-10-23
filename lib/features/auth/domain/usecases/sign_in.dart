import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';

class SignIn implements UseCase<AppUser, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call(SignInParams params) =>
      _repository.signIn(email: params.email.trim(), password: params.password);
}

class SignInParams {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;
}
