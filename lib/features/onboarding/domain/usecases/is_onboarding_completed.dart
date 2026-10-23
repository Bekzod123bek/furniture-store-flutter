import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/onboarding/domain/repositories/onboarding_repository.dart';

class IsOnboardingCompleted implements UseCase<bool, NoParams> {
  const IsOnboardingCompleted(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<bool>> call(NoParams params) => _repository.isCompleted();
}
