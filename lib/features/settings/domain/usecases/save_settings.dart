import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/repositories/settings_repository.dart';

class SaveSettings implements UseCase<void, AppSettings> {
  const SaveSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(AppSettings params) =>
      _repository.saveSettings(params);
}
