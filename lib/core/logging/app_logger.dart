import 'dart:developer' as developer;

/// Single place for logging. Replace the body of [error] with a crash
/// reporter (Firebase Crashlytics, Sentry) when the app goes to production.
abstract final class AppLogger {
  static void info(String message) =>
      developer.log(message, name: 'furniture_store');

  static void error(String message, Object error, [StackTrace? stack]) =>
      developer.log(
        message,
        name: 'furniture_store',
        level: 1000,
        error: error,
        stackTrace: stack,
      );
}
