import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/location/data/datasources/device_location_data_source.dart';
import 'package:furniture_store/features/location/data/datasources/geocoding_data_source.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:furniture_store/features/location/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl(this._device, this._geocoding);

  final DeviceLocationDataSource _device;
  final GeocodingDataSource _geocoding;

  @override
  Future<Result<GeoPoint>> currentPosition() => guard(_device.currentPosition);

  @override
  Future<Result<PlaceAddress>> addressAt(
    GeoPoint point, {
    required String languageCode,
  }) => guard(() => _geocoding.reverse(point, languageCode: languageCode));
}
