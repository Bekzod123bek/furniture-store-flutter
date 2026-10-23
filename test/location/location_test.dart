import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/location/data/datasources/geocoding_data_source.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:furniture_store/features/location/domain/repositories/location_repository.dart';
import 'package:furniture_store/features/location/domain/usecases/find_address.dart';
import 'package:furniture_store/features/location/domain/usecases/get_current_position.dart';
import 'package:furniture_store/features/location/presentation/cubit/location_picker_cubit.dart';

class _FakeLocationRepository implements LocationRepository {
  GeoPoint position = const GeoPoint(41.31, 69.28);
  Failure? positionFailure;
  final lookups = <GeoPoint>[];
  String? language;

  @override
  Future<Result<GeoPoint>> currentPosition() async =>
      positionFailure != null ? Err(positionFailure!) : Ok(position);

  @override
  Future<Result<PlaceAddress>> addressAt(
    GeoPoint point, {
    required String languageCode,
  }) async {
    lookups.add(point);
    language = languageCode;
    return Ok(PlaceAddress(point: point, city: 'Toshkent', street: 'Navoiy 1'));
  }
}

void main() {
  group('Nominatim answer', () {
    const point = GeoPoint(41.3, 69.2);

    test('takes road, house number and city', () {
      final address = NominatimGeocodingDataSource.parse(point, {
        'address': {
          'road': 'Amir Temur ko‘chasi',
          'house_number': '15',
          'city': 'Toshkent',
        },
      });
      expect(address.street, 'Amir Temur ko‘chasi 15');
      expect(address.city, 'Toshkent');
      expect(address.label, 'Amir Temur ko‘chasi 15, Toshkent');
      expect(address.hasAddress, isTrue);
    });

    test('falls back to the neighbourhood and to town or village', () {
      final address = NominatimGeocodingDataSource.parse(point, {
        'address': {'suburb': 'Chilonzor-9', 'town': 'Yangiyoʻl'},
      });
      expect(address.street, 'Chilonzor-9');
      expect(address.city, 'Yangiyoʻl');
    });

    test('a place without an address keeps only the point', () {
      final address = NominatimGeocodingDataSource.parse(point, {
        'error': 'Unable to geocode',
      });
      expect(address.hasAddress, isFalse);
      expect(address.label, point.toString());
    });

    test('a broken answer is rejected', () {
      expect(
        () => NominatimGeocodingDataSource.parse(point, ['x']),
        throwsFormatException,
      );
    });
  });

  group('LocationPickerCubit', () {
    late _FakeLocationRepository repository;
    late LocationPickerCubit cubit;

    setUp(() {
      repository = _FakeLocationRepository();
      cubit = LocationPickerCubit(
        getCurrentPosition: GetCurrentPosition(repository),
        findAddress: FindAddress(repository),
        debounce: const Duration(milliseconds: 10),
      );
    });
    tearDown(() => cubit.close());

    test('starts at the given point and finds its address', () async {
      const start = GeoPoint(41.0, 69.0);
      await cubit.start(initial: start, languageCode: 'ru');
      expect(cubit.state.center, start);
      expect(cubit.state.moveRequest, 1);
      expect(cubit.state.address!.street, 'Navoiy 1');
      expect(repository.language, 'ru');
    });

    test('without a point it starts at the device position', () async {
      await cubit.start(languageCode: 'uz');
      expect(cubit.state.center, repository.position);
      expect(cubit.state.locating, isFalse);
      expect(cubit.state.selection.city, 'Toshkent');
    });

    test(
      'a denied location shows the failure but still finds an address',
      () async {
        repository.positionFailure = const LocationFailure(
          LocationIssue.permissionDenied,
        );
        await cubit.start(languageCode: 'uz');
        expect(cubit.state.failure, isA<LocationFailure>());
        expect(cubit.state.center, GeoPoint.tashkent);
        expect(repository.lookups, [GeoPoint.tashkent]);
      },
    );

    test('dragging waits for the map to stop before looking up', () async {
      await cubit.start(initial: GeoPoint.tashkent, languageCode: 'uz');
      repository.lookups.clear();
      cubit
        ..cameraMoved(const GeoPoint(41.1, 69.1))
        ..cameraMoved(const GeoPoint(41.2, 69.2))
        ..cameraMoved(const GeoPoint(41.3, 69.3));
      expect(cubit.state.address, isNull);
      expect(cubit.state.resolving, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(repository.lookups, [const GeoPoint(41.3, 69.3)]);
      expect(cubit.state.address!.point, const GeoPoint(41.3, 69.3));
      expect(cubit.state.resolving, isFalse);
    });
  });
}
