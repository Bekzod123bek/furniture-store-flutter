import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:furniture_store/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._local);

  final OnboardingLocalDataSource _local;

  @override
  Future<Result<bool>> isCompleted() =>
      guard(() async => _local.readCompleted());

  @override
  Future<Result<void>> markCompleted() => guard(_local.writeCompleted);
}
