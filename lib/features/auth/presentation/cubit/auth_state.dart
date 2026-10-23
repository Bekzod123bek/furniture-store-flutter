import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';

enum AuthStatus {
  /// The saved session has not been checked yet.
  unknown,
  signedOut,
  signedIn,
}

class AuthState extends Equatable {
  const AuthState._(this.status, this.user);

  const AuthState.unknown() : this._(AuthStatus.unknown, null);

  const AuthState.signedOut() : this._(AuthStatus.signedOut, null);

  const AuthState.signedIn(AppUser user) : this._(AuthStatus.signedIn, user);

  final AuthStatus status;
  final AppUser? user;

  @override
  List<Object?> get props => [status, user];
}
