import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { onboarding, signedOut, signedIn }

class AuthState extends Equatable {
  const AuthState({required this.status, this.name = '', this.email = ''});

  final AuthStatus status;
  final String name;
  final String email;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  List<Object?> get props => [status, name, email];
}

/// Mock authentication: nothing leaves the device and no password is stored.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._prefs, {this.delay = const Duration(milliseconds: 600)})
    : super(_read(_prefs));

  static const _onboardingKey = 'onboarding_done';
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';

  final SharedPreferences _prefs;
  final Duration delay;

  static AuthState _read(SharedPreferences prefs) {
    if (!(prefs.getBool(_onboardingKey) ?? false)) {
      return const AuthState(status: AuthStatus.onboarding);
    }
    final email = prefs.getString(_emailKey);
    if (email == null) return const AuthState(status: AuthStatus.signedOut);
    return AuthState(
      status: AuthStatus.signedIn,
      name: prefs.getString(_nameKey) ?? '',
      email: email,
    );
  }

  Future<void> finishOnboarding() async {
    await _prefs.setBool(_onboardingKey, true);
    emit(const AuthState(status: AuthStatus.signedOut));
  }

  Future<void> signIn({required String email, String? name}) async {
    await Future<void>.delayed(delay);
    final displayName = (name == null || name.trim().isEmpty)
        ? _nameFromEmail(email)
        : name.trim();
    await _prefs.setString(_emailKey, email.trim());
    await _prefs.setString(_nameKey, displayName);
    emit(
      AuthState(
        status: AuthStatus.signedIn,
        name: displayName,
        email: email.trim(),
      ),
    );
  }

  Future<void> signOut() async {
    await _prefs.remove(_emailKey);
    await _prefs.remove(_nameKey);
    emit(const AuthState(status: AuthStatus.signedOut));
  }

  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'Guest';
    return local[0].toUpperCase() + local.substring(1);
  }
}
