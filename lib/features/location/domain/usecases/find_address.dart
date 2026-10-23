import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:furniture_store/features/location/domain/repositories/location_repository.dart';

class FindAddress implements UseCase<PlaceAddress, FindAddressParams> {
  const FindAddress(this._repository);

  final LocationRepository _repository;

  @override
  Future<Result<PlaceAddress>> call(FindAddressParams params) =>
      _repository.addressAt(params.point, languageCode: params.languageCode);
}

class FindAddressParams {
  const FindAddressParams(this.point, {required this.languageCode});

  final GeoPoint point;
  final String languageCode;
}
