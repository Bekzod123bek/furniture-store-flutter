import 'dart:async';

import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:geolocator/geolocator.dart';

abstract interface class DeviceLocationDataSource {
  Future<GeoPoint> currentPosition();
}

/// Reads the position with the `geolocator` plugin (GPS, network or the
/// browser's location API on the web).
class GeolocatorDataSource implements DeviceLocationDataSource {
  const GeolocatorDataSource();

  static const _timeout = Duration(seconds: 15);

  @override
  Future<GeoPoint> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationIssue.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    switch (permission) {
      case LocationPermission.denied:
        throw const LocationException(LocationIssue.permissionDenied);
      case LocationPermission.deniedForever:
        throw const LocationException(LocationIssue.permissionDeniedForever);
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        break;
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _timeout,
        ),
      );
      return GeoPoint(position.latitude, position.longitude);
    } on TimeoutException {
      throw const NetworkException('Location timed out');
    } on LocationServiceDisabledException {
      throw const LocationException(LocationIssue.serviceDisabled);
    } on PermissionDeniedException {
      throw const LocationException(LocationIssue.permissionDenied);
    }
  }
}
