import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Stream<AppUser?> watchUser() => _remote.watchUser();

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) => guard(() => _remote.signIn(email, password));

  @override
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) => guard(() => _remote.register(name, email, password));

  @override
  Future<Result<void>> signOut() => guard(_remote.signOut);

  @override
  Future<Result<void>> sendPasswordReset(String email) =>
      guard(() => _remote.sendPasswordReset(email));
}
