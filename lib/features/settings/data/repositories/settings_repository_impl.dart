import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<Result<AppSettings>> getSettings() => guard(() async {
    final theme = _local.readThemeMode();
    final language = _local.readLanguage();
    return AppSettings(
      theme: ThemePreference.values.firstWhere(
        (p) => p.name == theme,
        orElse: () => ThemePreference.system,
      ),
      language: AppLanguage.values.firstWhere(
        (l) => l.name == language,
        orElse: () => AppLanguage.system,
      ),
    );
  });

  @override
  Future<Result<void>> saveSettings(AppSettings settings) => guard(
    () => _local.write(
      themeMode: settings.theme.name,
      language: settings.language.name,
    ),
  );
}
