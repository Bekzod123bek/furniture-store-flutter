import 'dart:async';
import 'dart:convert';

import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:http/http.dart' as http;

abstract interface class GeocodingDataSource {
  Future<PlaceAddress> reverse(GeoPoint point, {required String languageCode});
}

/// Reverse geocoding with OpenStreetMap Nominatim. Free, no key, but limited
/// to about one request per second; switch to a paid geocoder (Yandex,
/// Google, MapTiler) when the app has many users.
class NominatimGeocodingDataSource implements GeocodingDataSource {
  NominatimGeocodingDataSource(this._client);

  static const _host = 'nominatim.openstreetmap.org';
  static const _timeout = Duration(seconds: 10);

  /// Nominatim's usage policy asks every app to identify itself.
  static const _userAgent = 'FurnitureStore/1.0 (dev.bekzod.furniture_store)';

  final http.Client _client;

  @override
  Future<PlaceAddress> reverse(
    GeoPoint point, {
    required String languageCode,
  }) async {
    final uri = Uri.https(_host, '/reverse', {
      'format': 'jsonv2',
      'lat': point.latitude.toString(),
      'lon': point.longitude.toString(),
      'zoom': '18',
      'addressdetails': '1',
      'accept-language': languageCode,
    });
    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'User-Agent': _userAgent})
          .timeout(_timeout);
    } on TimeoutException {
      throw const NetworkException('Geocoding timed out');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
    if (response.statusCode != 200) {
      throw ServerException('Geocoding failed: ${response.statusCode}');
    }
    return parse(point, jsonDecode(utf8.decode(response.bodyBytes)));
  }

  /// Turns a Nominatim answer into a [PlaceAddress]. Places without an
  /// address (fields, water) give an address with empty city and street.
  static PlaceAddress parse(GeoPoint point, Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Geocoding answer is not an object');
    }
    final address = json['address'];
    if (address is! Map<String, dynamic>) return PlaceAddress(point: point);

    String? pick(List<String> keys) {
      for (final key in keys) {
        final value = address[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
      return null;
    }

    final road = pick(['road', 'pedestrian', 'footway', 'residential']);
    final house = pick(['house_number']);
    final area = pick(['neighbourhood', 'suburb', 'quarter']);
    final street = [
      if (road != null) house == null ? road : '$road $house',
      if (road == null && area != null) area,
    ].join();
    final city = pick(['city', 'town', 'village', 'county', 'state']) ?? '';
    return PlaceAddress(point: point, city: city, street: street);
  }
}
