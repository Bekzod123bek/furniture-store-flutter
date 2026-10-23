import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<Result<AppSettings>> getSettings();
  Future<Result<void>> saveSettings(AppSettings settings);
}
