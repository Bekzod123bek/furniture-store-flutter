import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_store/core/firebase/firebase_call.dart';
import 'package:furniture_store/core/session/current_user_provider.dart';
import 'package:furniture_store/features/cart/data/models/cart_snapshot_model.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';

abstract interface class CartRemoteDataSource {
  Future<CartSnapshot> fetchCart();
  Future<void> writeCart(CartSnapshot snapshot);
}

/// Stores the cart in `users/{uid}/state/cart`, so it follows the user to
/// another device.
class FirestoreCartDataSource implements CartRemoteDataSource {
  const FirestoreCartDataSource(this._firestore, this._user);

  final FirebaseFirestore _firestore;
  final CurrentUserProvider _user;

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection('users')
      .doc(_user.requireUid)
      .collection('state')
      .doc('cart');

  @override
  Future<CartSnapshot> fetchCart() async {
    final snapshot = await firebaseCall(() => _doc.get());
    final data = snapshot.data();
    return data == null
        ? const CartSnapshot()
        : CartSnapshotModel.fromMap(data);
  }

  @override
  Future<void> writeCart(CartSnapshot snapshot) =>
      queuedWrite(() => _doc.set(CartSnapshotModel.toMap(snapshot)));
}
