import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/auth/domain/usecases/register.dart';
import 'package:furniture_store/features/auth/domain/usecases/send_password_reset.dart';
import 'package:furniture_store/features/auth/domain/usecases/sign_in.dart';
import 'package:furniture_store/features/auth/presentation/cubit/login_state.dart';

/// Drives the sign-in / register form. On success nothing needs to be done
/// here: `AuthCubit` sees the new session and the app switches screens.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SignIn signIn,
    required Register register,
    required SendPasswordReset sendPasswordReset,
  }) : _signIn = signIn,
       _register = register,
       _sendPasswordReset = sendPasswordReset,
       super(const LoginState());

  final SignIn _signIn;
  final Register _register;
  final SendPasswordReset _sendPasswordReset;

  void setMode(LoginMode mode) =>
      emit(state.copyWith(mode: mode, failure: () => null));

  Future<void> submit({
    required String email,
    required String password,
    String name = '',
  }) async {
    if (state.submitting) return;
    emit(state.copyWith(submitting: true, failure: () => null));
    final result = switch (state.mode) {
      LoginMode.signIn => await _signIn(
        SignInParams(email: email, password: password),
      ),
      LoginMode.register => await _register(
        RegisterParams(name: name, email: email, password: password),
      ),
    };
    if (isClosed) return;
    emit(
      state.copyWith(submitting: false, failure: () => result.failureOrNull),
    );
  }

  Future<void> resetPassword(String email) async {
    if (state.submitting) return;
    emit(state.copyWith(submitting: true, failure: () => null));
    final result = await _sendPasswordReset(email);
    if (isClosed) return;
    emit(
      state.copyWith(
        submitting: false,
        failure: () => result.failureOrNull,
        resetEmailSent: result is Ok,
      ),
    );
  }

  /// Hides the "reset e-mail sent" notice after it has been shown.
  void resetNoticeShown() => emit(state.copyWith(resetEmailSent: false));
}
