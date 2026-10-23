import 'package:equatable/equatable.dart';

/// A position on Earth in degrees.
class GeoPoint extends Equatable {
  const GeoPoint(this.latitude, this.longitude);

  /// Where the map opens when the user's position is unknown.
  static const tashkent = GeoPoint(41.2995, 69.2401);

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];

  @override
  String toString() =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}
