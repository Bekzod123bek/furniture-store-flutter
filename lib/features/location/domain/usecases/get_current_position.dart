import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/repositories/location_repository.dart';

class GetCurrentPosition implements UseCase<GeoPoint, NoParams> {
  const GetCurrentPosition(this._repository);

  final LocationRepository _repository;

  @override
  Future<Result<GeoPoint>> call(NoParams params) =>
      _repository.currentPosition();
}
