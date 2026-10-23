import 'package:furniture_store/features/auth/domain/entities/app_user.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.watchUser();
}
