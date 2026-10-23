import 'package:furniture_store/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingLocalDataSource {
  bool readCompleted();
  Future<void> writeCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl(this._prefs);

  static const _key = 'onboarding_done';

  final SharedPreferences _prefs;

  @override
  bool readCompleted() => _prefs.getBool(_key) ?? false;

  @override
  Future<void> writeCompleted() async {
    if (!await _prefs.setBool(_key, true)) {
      throw const CacheException('Could not save onboarding state');
    }
  }
}
