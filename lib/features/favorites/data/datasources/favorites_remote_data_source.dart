import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_store/core/firebase/firebase_call.dart';
import 'package:furniture_store/core/session/current_user_provider.dart';
import 'package:furniture_store/core/utils/json_reader.dart';

abstract interface class FavoritesRemoteDataSource {
  Future<List<String>> fetchIds();
  Future<void> writeIds(List<String> ids);
}

/// Stores favorite product ids in `users/{uid}/state/favorites`.
class FirestoreFavoritesDataSource implements FavoritesRemoteDataSource {
  const FirestoreFavoritesDataSource(this._firestore, this._user);

  final FirebaseFirestore _firestore;
  final CurrentUserProvider _user;

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection('users')
      .doc(_user.requireUid)
      .collection('state')
      .doc('favorites');

  @override
  Future<List<String>> fetchIds() async {
    final snapshot = await firebaseCall(() => _doc.get());
    final data = snapshot.data();
    return data == null ? const [] : JsonReader(data).list<String>('ids');
  }

  @override
  Future<void> writeIds(List<String> ids) =>
      queuedWrite(() => _doc.set({'ids': ids}));
}
