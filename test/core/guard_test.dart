import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/firebase/firebase_call.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

void main() {
  group('guard', () {
    test('wraps a value in Ok', () async {
      final result = await guard(() async => 42);
      expect(result, isA<Ok<int>>());
      expect(result.valueOrNull, 42);
    });

    test('turns each exception into its failure type', () async {
      Future<Failure?> failureOf(Exception e) async =>
          (await guard<int>(() async => throw e)).failureOrNull;

      expect(await failureOf(const NetworkException()), isA<NetworkFailure>());
      expect(await failureOf(const ServerException()), isA<ServerFailure>());
      expect(await failureOf(const CacheException()), isA<CacheFailure>());
      expect(
        await failureOf(const NotFoundException()),
        isA<NotFoundFailure>(),
      );
      expect(
        await failureOf(const InvalidCredentialsException()),
        isA<InvalidCredentialsFailure>(),
      );
      expect(
        await failureOf(const ValidationException(ValidationIssue.emptyCart)),
        const ValidationFailure(ValidationIssue.emptyCart),
      );
      expect(
        await failureOf(
          const LocationException(LocationIssue.permissionDenied),
        ),
        const LocationFailure(LocationIssue.permissionDenied),
      );
      expect(await failureOf(const FormatException('x')), isA<ServerFailure>());
      expect(await failureOf(Exception('boom')), isA<UnexpectedFailure>());
    });
  });

  group('mapFirebaseException', () {
    AppException map(String code) =>
        mapFirebaseException(FirebaseException(plugin: 'test', code: code));

    test('connection problems become NetworkException', () {
      expect(map('unavailable'), isA<NetworkException>());
      expect(map('network-request-failed'), isA<NetworkException>());
      expect(map('deadline-exceeded'), isA<NetworkException>());
    });

    test('sign-in errors', () {
      expect(map('invalid-credential'), isA<InvalidCredentialsException>());
      expect(map('wrong-password'), isA<InvalidCredentialsException>());
      expect(map('email-already-in-use'), isA<ValidationException>());
      expect(map('weak-password'), isA<ValidationException>());
    });

    test('unknown codes become ServerException', () {
      expect(map('permission-denied'), isA<ServerException>());
    });
  });

  test('every failure has a message for the user in every language', () {
    final failures = <Failure>[
      const NetworkFailure(),
      const ServerFailure(),
      const CacheFailure(),
      const NotFoundFailure(),
      const InvalidCredentialsFailure(),
      const UnexpectedFailure(),
      for (final issue in ValidationIssue.values) ValidationFailure(issue),
      for (final issue in LocationIssue.values) LocationFailure(issue),
    ];
    for (final code in ['uz', 'ru', 'en']) {
      final l10n = lookupAppLocalizations(Locale(code));
      final texts = {for (final f in failures) f.localized(l10n)};
      expect(texts.every((t) => t.isNotEmpty), isTrue);
      // Different problems must not share one vague message.
      expect(texts.length, greaterThan(failures.length - 2), reason: code);
    }
  });
}
