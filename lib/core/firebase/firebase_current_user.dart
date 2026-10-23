import 'package:firebase_auth/firebase_auth.dart';
import 'package:furniture_store/core/session/current_user_provider.dart';

class FirebaseCurrentUser implements CurrentUserProvider {
  const FirebaseCurrentUser(this._auth);

  final FirebaseAuth _auth;

  @override
  String? get uid => _auth.currentUser?.uid;
}
