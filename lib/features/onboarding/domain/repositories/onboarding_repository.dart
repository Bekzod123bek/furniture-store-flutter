import 'package:furniture_store/core/result/result.dart';

abstract interface class OnboardingRepository {
  Future<Result<bool>> isCompleted();
  Future<Result<void>> markCompleted();
}
