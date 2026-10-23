import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';

enum LoginMode { signIn, register }

class LoginState extends Equatable {
  const LoginState({
    this.mode = LoginMode.signIn,
    this.submitting = false,
    this.failure,
    this.resetEmailSent = false,
  });

  final LoginMode mode;
  final bool submitting;
  final Failure? failure;

  /// Set after a password reset e-mail has been sent.
  final bool resetEmailSent;

  LoginState copyWith({
    LoginMode? mode,
    bool? submitting,
    Failure? Function()? failure,
    bool? resetEmailSent,
  }) => LoginState(
    mode: mode ?? this.mode,
    submitting: submitting ?? this.submitting,
    failure: failure != null ? failure() : this.failure,
    resetEmailSent: resetEmailSent ?? this.resetEmailSent,
  );

  @override
  List<Object?> get props => [mode, submitting, failure, resetEmailSent];
}
