import 'package:firebase_auth/firebase_auth.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';

abstract final class UserModel {
  static AppUser fromFirebase(User user) {
    final email = user.email ?? '';
    return AppUser(
      uid: user.uid,
      name: _displayName(user.displayName, email),
      email: email,
    );
  }

  static String _displayName(String? displayName, String email) {
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
    final local = email.split('@').first;
    if (local.isEmpty) return 'Guest';
    return local[0].toUpperCase() + local.substring(1);
  }
}
