import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';

/// A point on the map with the address found for it. [city] and [street]
/// may be empty when the map has no address there.
class PlaceAddress extends Equatable {
  const PlaceAddress({required this.point, this.city = '', this.street = ''});

  final GeoPoint point;
  final String city;

  /// Street and house number, for example `Amir Temur ko'chasi 15`.
  final String street;

  bool get hasAddress => city.isNotEmpty || street.isNotEmpty;

  /// One line for display; falls back to the coordinates.
  String get label {
    final parts = [street, city].where((p) => p.isNotEmpty).join(', ');
    return parts.isEmpty ? point.toString() : parts;
  }

  @override
  List<Object?> get props => [point, city, street];
}
