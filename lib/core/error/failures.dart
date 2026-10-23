import 'package:equatable/equatable.dart';

/// Why a request was rejected. A stable code, so the UI can show the right
/// text in the user's language.
enum ValidationIssue {
  emptyCart,
  incompleteAddress,
  orderNotCancellable,
  emailAlreadyInUse,
  weakPassword,
  invalidEmail,
  accountDisabled,
  tooManyAttempts,
  signInAgain,
  signedOut,
  photoTooLarge,
  photoAccessDenied,
  photoUnreadable,
  notARoom,
  analysisLimitReached,
}

/// Why the device location could not be read.
enum LocationIssue {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

/// An expected, recoverable error returned from the domain layer.
///
/// [message] is for logs and debugging only. The UI decides what to show
/// to the user based on the failure type (see `failure_messages.dart`).
sealed class Failure extends Equatable {
  const Failure([this.message = '']);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// No connection or the request timed out.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// The server answered with an error or sent data we could not read.
final class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Reading or writing local storage failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

/// The requested item does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

/// Wrong email or password.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message]);
}

/// Input broke a business rule (for example, an empty cart at checkout).
final class ValidationFailure extends Failure {
  const ValidationFailure(this.issue, [super.message]);

  final ValidationIssue issue;

  @override
  List<Object?> get props => [issue, message];
}

/// The device location is off or not allowed.
final class LocationFailure extends Failure {
  const LocationFailure(this.issue, [super.message]);

  final LocationIssue issue;

  @override
  List<Object?> get props => [issue, message];
}

/// Anything we did not expect. Always logged.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message]);
}
