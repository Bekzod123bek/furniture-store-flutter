import 'package:flutter/widgets.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

export 'package:furniture_store/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  /// Texts in the current language.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Current language code, for example `uz`.
  String get languageCode => Localizations.localeOf(this).languageCode;
}
