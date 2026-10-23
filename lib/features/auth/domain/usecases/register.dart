import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';

class Register implements UseCase<AppUser, RegisterParams> {
  const Register(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call(RegisterParams params) => _repository.register(
    name: params.name.trim(),
    email: params.email.trim(),
    password: params.password,
  );
}

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
