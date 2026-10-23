import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';

class ShippingAddress extends Equatable {
  const ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.city,
    required this.street,
    this.location,
  });

  final String fullName;
  final String phone;
  final String city;
  final String street;

  /// The exact point picked on the map, so the courier can navigate to it.
  final GeoPoint? location;

  /// Whether every field has some text and the phone has enough digits.
  bool get isComplete =>
      fullName.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      street.trim().isNotEmpty &&
      phone.replaceAll(RegExp(r'\D'), '').length >= 9;

  /// Two-line text for lists and receipts.
  String get formatted => '$fullName, $phone\n$street, $city';

  @override
  List<Object?> get props => [fullName, phone, city, street, location];
}
