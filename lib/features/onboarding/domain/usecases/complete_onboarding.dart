import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboarding implements UseCase<void, NoParams> {
  const CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.markCompleted();
}
