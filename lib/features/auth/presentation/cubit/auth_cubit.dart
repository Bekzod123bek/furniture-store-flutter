import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/auth/domain/usecases/sign_out.dart';
import 'package:furniture_store/features/auth/domain/usecases/watch_auth_state.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_state.dart';

/// Follows the Firebase session. Signing in or out happens elsewhere (see
/// `LoginCubit`); this cubit only reflects the result.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required WatchAuthState watchAuthState, required SignOut signOut})
    : _signOut = signOut,
      super(const AuthState.unknown()) {
    _subscription = watchAuthState().listen(
      (user) => emit(
        user == null ? const AuthState.signedOut() : AuthState.signedIn(user),
      ),
      onError: (Object error, StackTrace stack) {
        AppLogger.error('Auth stream failed', error, stack);
        emit(const AuthState.signedOut());
      },
    );
  }

  final SignOut _signOut;
  late final StreamSubscription<Object?> _subscription;

  Future<void> signOut() async {
    final result = await _signOut(const NoParams());
    final failure = result.failureOrNull;
    if (failure != null) AppLogger.info('Sign out failed: ${failure.message}');
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
