import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/firebase/firebase_call.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/core/session/current_user_provider.dart';
import 'package:furniture_store/features/orders/data/models/order_model.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<Order>> fetchOrders();
  Future<void> createOrder(Order order);
  Future<void> setCancelled(String orderId);
  Future<ShippingAddress?> fetchAddress();
  Future<void> writeAddress(ShippingAddress address);
}

/// Orders live in `users/{uid}/orders`; the last delivery address is a field
/// of `users/{uid}`.
class FirestoreOrdersDataSource implements OrdersRemoteDataSource {
  const FirestoreOrdersDataSource(this._firestore, this._user);

  final FirebaseFirestore _firestore;
  final CurrentUserProvider _user;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection('users').doc(_user.requireUid);

  CollectionReference<Map<String, dynamic>> get _orders =>
      _userDoc.collection('orders');

  @override
  Future<List<Order>> fetchOrders() async {
    final snapshot = await firebaseCall(
      () => _orders.orderBy('createdAt', descending: true).get(),
    );
    final orders = <Order>[];
    for (final doc in snapshot.docs) {
      try {
        orders.add(OrderModel.fromMap(doc.id, doc.data()));
      } on FormatException catch (e, stack) {
        AppLogger.error('Skipped malformed order "${doc.id}"', e, stack);
      }
    }
    return orders;
  }

  @override
  Future<void> createOrder(Order order) async {
    final doc = _orders.doc(order.id);
    try {
      await firebaseCall(() => doc.set(OrderModel.toMap(order)));
    } on ServerException {
      // A first attempt that timed out may still have reached the server. The
      // retry is then refused by the rules (orders cannot be overwritten), so
      // check whether the order is already there before reporting a failure.
      final existing = await firebaseCall(() => doc.get());
      if (!existing.exists) rethrow;
    }
  }

  @override
  Future<void> setCancelled(String orderId) =>
      firebaseCall(() => _orders.doc(orderId).update({'status': 'cancelled'}));

  @override
  Future<ShippingAddress?> fetchAddress() async {
    final snapshot = await firebaseCall(() => _userDoc.get());
    final address = snapshot.data()?['address'];
    if (address == null) return null;
    return OrderModel.addressFromMap(address);
  }

  @override
  Future<void> writeAddress(ShippingAddress address) => queuedWrite(
    () => _userDoc.set({
      'address': OrderModel.addressToMap(address),
    }, SetOptions(merge: true)),
  );
}
