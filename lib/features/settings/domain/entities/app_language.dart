/// Language of the app. [system] follows the phone, falling back to Uzbek.
enum AppLanguage {
  system,
  uz,
  ru,
  en;

  /// Supported language codes, in the order they are offered.
  static const codes = ['uz', 'ru', 'en'];
}
