import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.theme = ThemePreference.system,
    this.language = AppLanguage.system,
  });

  final ThemePreference theme;
  final AppLanguage language;

  AppSettings copyWith({ThemePreference? theme, AppLanguage? language}) =>
      AppSettings(
        theme: theme ?? this.theme,
        language: language ?? this.language,
      );

  @override
  List<Object?> get props => [theme, language];
}
