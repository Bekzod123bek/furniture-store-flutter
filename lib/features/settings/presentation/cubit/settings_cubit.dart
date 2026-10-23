import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/features/settings/domain/usecases/save_settings.dart';

/// Theme and language. The first value is read before `runApp`, so the first
/// frame already has the right colours and texts.
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit({
    required AppSettings initial,
    required SaveSettings saveSettings,
  }) : _save = saveSettings,
       super(initial);

  final SaveSettings _save;

  Future<void> setTheme(ThemePreference theme) =>
      _update(state.copyWith(theme: theme));

  Future<void> setLanguage(AppLanguage language) =>
      _update(state.copyWith(language: language));

  /// The locale to force, or `null` to follow the phone.
  Locale? get locale => switch (state.language) {
    AppLanguage.system => null,
    AppLanguage.uz => const Locale('uz'),
    AppLanguage.ru => const Locale('ru'),
    AppLanguage.en => const Locale('en'),
  };

  Future<void> _update(AppSettings next) async {
    emit(next);
    final result = await _save(next);
    final failure = result.failureOrNull;
    if (failure != null) {
      AppLogger.info('Settings not saved: ${failure.message}');
    }
  }
}
