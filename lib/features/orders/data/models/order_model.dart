import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint, Order;
import 'package:furniture_store/core/utils/json_reader.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/order_line.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';

/// Converts between [Order] and the Firestore `users/{uid}/orders/{id}`
/// document.
abstract final class OrderModel {
  static Order fromMap(String id, Map<String, dynamic> map) {
    final json = JsonReader(map);
    final paymentName = json.string('paymentMethod');
    return Order(
      id: id,
      createdAt: _date(map['createdAt']),
      lines: [
        for (final l in json.objects('lines'))
          OrderLine(
            productId: l.string('productId'),
            name: l.string('name'),
            image: l.string('image'),
            color: l.string('color'),
            quantity: l.integer('quantity'),
            price: l.integer('price'),
          ),
      ],
      subtotal: json.integer('subtotal'),
      discount: json.integer('discount'),
      delivery: json.integer('delivery'),
      address: addressFromMap(map['address']),
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == paymentName,
        orElse: () => PaymentMethod.cashOnDelivery,
      ),
      status: OrderStatus.parse(json.optionalString('status')),
    );
  }

  /// The map sent to Firestore. `createdAt` is set by the server, which the
  /// security rules require.
  static Map<String, Object?> toMap(Order order) => {
    'lines': [
      for (final l in order.lines)
        {
          'productId': l.productId,
          'name': l.name,
          'image': l.image,
          'color': l.color,
          'quantity': l.quantity,
          'price': l.price,
        },
    ],
    'subtotal': order.subtotal,
    'discount': order.discount,
    'delivery': order.delivery,
    'total': order.total,
    'address': addressToMap(order.address),
    'paymentMethod': order.paymentMethod.name,
    'status': order.status.name,
    'createdAt': FieldValue.serverTimestamp(),
  };

  static ShippingAddress addressFromMap(Object? value) {
    if (value is! Map) {
      throw const FormatException('"address" must be an object');
    }
    final json = JsonReader(value.cast<String, dynamic>());
    return ShippingAddress(
      fullName: json.string('fullName'),
      phone: json.string('phone'),
      city: json.string('city'),
      street: json.string('street'),
      location: _point(json),
    );
  }

  static Map<String, Object> addressToMap(ShippingAddress a) => {
    'fullName': a.fullName,
    'phone': a.phone,
    'city': a.city,
    'street': a.street,
    if (a.location case final point?) ...{
      'lat': point.latitude,
      'lng': point.longitude,
    },
  };

  static GeoPoint? _point(JsonReader json) {
    final lat = json.optionalNumber('lat');
    final lng = json.optionalNumber('lng');
    if (lat == null || lng == null) return null;
    if (lat.abs() > 90 || lng.abs() > 180) return null;
    return GeoPoint(lat, lng);
  }

  /// A just-written order has no server time yet; fall back to "now".
  static DateTime _date(Object? value) => switch (value) {
    Timestamp() => value.toDate(),
    String() => DateTime.parse(value),
    _ => DateTime.now(),
  };
}
