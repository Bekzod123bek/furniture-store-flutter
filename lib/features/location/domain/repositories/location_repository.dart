import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';

abstract interface class LocationRepository {
  /// Where the device is now. Asks for permission when needed.
  Future<Result<GeoPoint>> currentPosition();

  /// The street address at [point], written in [languageCode] if possible.
  Future<Result<PlaceAddress>> addressAt(
    GeoPoint point, {
    required String languageCode,
  });
}
