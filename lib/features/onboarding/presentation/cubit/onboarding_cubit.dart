import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/onboarding/domain/usecases/complete_onboarding.dart';

/// State is `true` once the user has seen (or skipped) the introduction.
class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit({
    required bool completed,
    required CompleteOnboarding completeOnboarding,
  }) : _complete = completeOnboarding,
       super(completed);

  final CompleteOnboarding _complete;

  Future<void> finish() async {
    emit(true);
    await _complete(const NoParams());
  }
}
