import 'package:furniture_store/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalDataSource {
  /// Stored values, or `null` when nothing was saved yet.
  String? readThemeMode();
  String? readLanguage();
  Future<void> write({required String themeMode, required String language});
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._prefs);

  static const _themeKey = 'theme_mode';
  static const _languageKey = 'app_language';

  final SharedPreferences _prefs;

  @override
  String? readThemeMode() => _prefs.getString(_themeKey);

  @override
  String? readLanguage() => _prefs.getString(_languageKey);

  @override
  Future<void> write({
    required String themeMode,
    required String language,
  }) async {
    final saved =
        await _prefs.setString(_themeKey, themeMode) &&
        await _prefs.setString(_languageKey, language);
    if (!saved) throw const CacheException('Could not save the settings');
  }
}
