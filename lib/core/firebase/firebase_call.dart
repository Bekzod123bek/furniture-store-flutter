import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/logging/app_logger.dart';

const _defaultTimeout = Duration(seconds: 15);

/// Runs a Firebase [action] and converts SDK errors into [AppException]s.
///
/// Use for reads and for writes whose result matters to the user (placing an
/// order). Writes that may wait offline use [queuedWrite] instead.
Future<T> firebaseCall<T>(
  Future<T> Function() action, {
  Duration timeout = _defaultTimeout,
}) async {
  try {
    return await action().timeout(timeout);
  } on TimeoutException {
    throw const NetworkException('The request timed out');
  } on FirebaseException catch (e) {
    throw mapFirebaseException(e);
  }
}

/// Runs a Firestore write that is allowed to wait while the device is offline.
///
/// Firestore keeps the write in its local queue and sends it later, but the
/// returned future only completes once the server confirms. We therefore wait
/// briefly: a rejected write (for example `permission-denied`) fails fast,
/// while a slow or offline one is treated as queued.
Future<void> queuedWrite(
  Future<void> Function() action, {
  Duration wait = const Duration(seconds: 3),
}) async {
  try {
    await action().timeout(wait);
  } on TimeoutException {
    AppLogger.info('Write is queued until the connection is back');
  } on FirebaseException catch (e) {
    throw mapFirebaseException(e);
  }
}

/// Maps a [FirebaseException] code to one of our exception types.
AppException mapFirebaseException(FirebaseException e) {
  final detail = '${e.plugin}/${e.code}: ${e.message ?? ''}';
  return switch (e.code) {
    'unavailable' ||
    'deadline-exceeded' ||
    'network-request-failed' ||
    'cancelled' => NetworkException(detail),
    'not-found' => NotFoundException(detail),
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' ||
    'invalid-login-credentials' => InvalidCredentialsException(detail),
    'email-already-in-use' => ValidationException(
      ValidationIssue.emailAlreadyInUse,
      detail,
    ),
    'weak-password' => ValidationException(
      ValidationIssue.weakPassword,
      detail,
    ),
    'invalid-email' => ValidationException(
      ValidationIssue.invalidEmail,
      detail,
    ),
    'user-disabled' => ValidationException(
      ValidationIssue.accountDisabled,
      detail,
    ),
    'too-many-requests' => ValidationException(
      ValidationIssue.tooManyAttempts,
      detail,
    ),
    'requires-recent-login' => ValidationException(
      ValidationIssue.signInAgain,
      detail,
    ),
    _ => ServerException(detail),
  };
}
