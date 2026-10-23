import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  const GetSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<AppSettings>> call(NoParams params) =>
      _repository.getSettings();
}
