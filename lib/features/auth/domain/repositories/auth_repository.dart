import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  /// Emits the signed-in user, or `null` when signed out. The first event
  /// arrives once the saved session has been restored.
  Stream<AppUser?> watchUser();

  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> signOut();

  Future<Result<void>> sendPasswordReset(String email);
}
