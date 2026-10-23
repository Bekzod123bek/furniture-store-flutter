import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

extension ThemePreferenceLabel on ThemePreference {
  String label(AppLocalizations l10n) => switch (this) {
    ThemePreference.system => l10n.themeSystem,
    ThemePreference.light => l10n.themeLight,
    ThemePreference.dark => l10n.themeDark,
  };
}

extension AppLanguageLabel on AppLanguage {
  /// Each language is shown in its own language, so anyone can find theirs.
  String label(AppLocalizations l10n) => switch (this) {
    AppLanguage.system => l10n.languageSystem,
    AppLanguage.uz => 'Oʻzbekcha',
    AppLanguage.ru => 'Русский',
    AppLanguage.en => 'English',
  };
}
