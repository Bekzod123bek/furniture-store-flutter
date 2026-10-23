import 'package:furniture_store/core/error/failures.dart';

/// Exceptions thrown by data sources. Repositories catch them and return a
/// typed `Failure` instead, so they never reach the presentation layer.
sealed class AppException implements Exception {
  const AppException([this.message = '']);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

final class ServerException extends AppException {
  const ServerException([super.message]);
}

final class CacheException extends AppException {
  const CacheException([super.message]);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

final class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException([super.message]);
}

/// Input was rejected (weak password, e-mail already used, empty cart...).
final class ValidationException extends AppException {
  const ValidationException(this.issue, [super.message]);

  final ValidationIssue issue;
}

/// The device location could not be read.
final class LocationException extends AppException {
  const LocationException(this.issue, [super.message]);

  final LocationIssue issue;
}
