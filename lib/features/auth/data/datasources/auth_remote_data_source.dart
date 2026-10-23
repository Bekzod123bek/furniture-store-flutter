import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/firebase/firebase_call.dart';
import 'package:furniture_store/features/auth/data/models/user_model.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRemoteDataSource {
  Stream<AppUser?> watchUser();
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> register(String name, String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordReset(String email);
}

/// E-mail and password sign-in with Firebase Authentication. A small profile
/// document is stored in `users/{uid}`.
class FirebaseAuthDataSource implements AuthRemoteDataSource {
  const FirebaseAuthDataSource(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<AppUser?> watchUser() => _auth.userChanges().map(
    (user) => user == null ? null : UserModel.fromFirebase(user),
  );

  @override
  Future<AppUser> signIn(String email, String password) =>
      firebaseCall(() async {
        final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return UserModel.fromFirebase(_requireUser(credential));
      });

  @override
  Future<AppUser> register(String name, String email, String password) =>
      firebaseCall(() async {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = _requireUser(credential);
        await user.updateDisplayName(name);
        await user.reload();
        final refreshed = _auth.currentUser ?? user;
        await queuedWrite(
          () => _firestore.collection('users').doc(refreshed.uid).set({
            'name': name,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true)),
        );
        return UserModel.fromFirebase(refreshed);
      });

  @override
  Future<void> signOut() => firebaseCall(_auth.signOut);

  @override
  Future<void> sendPasswordReset(String email) =>
      firebaseCall(() => _auth.sendPasswordResetEmail(email: email));

  User _requireUser(UserCredential credential) =>
      credential.user ?? (throw const ServerException('No user returned'));
}
