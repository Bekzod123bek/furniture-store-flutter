import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:furniture_store/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/features/settings/domain/usecases/get_settings.dart';
import 'package:furniture_store/features/settings/domain/usecases/save_settings.dart';
import 'package:furniture_store/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsRepositoryImpl> _repository(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  return SettingsRepositoryImpl(
    SettingsLocalDataSourceImpl(await SharedPreferences.getInstance()),
  );
}

void main() {
  test('defaults to the system theme and the phone language', () async {
    final repo = await _repository({});
    expect(
      (await GetSettings(repo)(const NoParams())).valueOrNull,
      const AppSettings(),
    );
  });

  test('keeps the theme saved by the previous app version', () async {
    final repo = await _repository({'theme_mode': 'dark'});
    final settings = (await repo.getSettings()).valueOrNull!;
    expect(settings.theme, ThemePreference.dark);
    expect(settings.language, AppLanguage.system);
  });

  test('saves and restores theme and language', () async {
    final repo = await _repository({});
    final cubit = SettingsCubit(
      initial: const AppSettings(),
      saveSettings: SaveSettings(repo),
    );
    await cubit.setLanguage(AppLanguage.ru);
    await cubit.setTheme(ThemePreference.light);
    expect(cubit.locale, const Locale('ru'));

    final restored = (await repo.getSettings()).valueOrNull!;
    expect(restored.language, AppLanguage.ru);
    expect(restored.theme, ThemePreference.light);
    await cubit.close();
  });

  test('unknown stored values fall back to defaults', () async {
    final repo = await _repository({
      'theme_mode': 'purple',
      'app_language': 'klingon',
    });
    expect((await repo.getSettings()).valueOrNull, const AppSettings());
  });

  test('"phone language" leaves the locale to the system', () {
    final cubit = SettingsCubit(
      initial: const AppSettings(),
      saveSettings: SaveSettings(SettingsRepositoryImplStub()),
    );
    expect(cubit.locale, isNull);
  });
}

class SettingsRepositoryImplStub extends SettingsRepositoryImpl {
  SettingsRepositoryImplStub() : super(_NoopLocal());
}

class _NoopLocal implements SettingsLocalDataSource {
  @override
  String? readLanguage() => null;

  @override
  String? readThemeMode() => null;

  @override
  Future<void> write({
    required String themeMode,
    required String language,
  }) async {}
}
