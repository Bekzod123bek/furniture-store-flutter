import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

/// User-facing text for each failure, in the current language.
extension FailureMessage on Failure {
  String localized(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    ServerFailure() => l10n.errorServer,
    CacheFailure() => l10n.errorCache,
    NotFoundFailure() => l10n.errorNotFound,
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    UnexpectedFailure() => l10n.errorUnexpected,
    ValidationFailure(:final issue) => switch (issue) {
      ValidationIssue.emptyCart => l10n.errorEmptyCart,
      ValidationIssue.incompleteAddress => l10n.errorIncompleteAddress,
      ValidationIssue.orderNotCancellable => l10n.errorOrderNotCancellable,
      ValidationIssue.emailAlreadyInUse => l10n.errorEmailInUse,
      ValidationIssue.weakPassword => l10n.errorWeakPassword,
      ValidationIssue.invalidEmail => l10n.errorInvalidEmail,
      ValidationIssue.accountDisabled => l10n.errorAccountDisabled,
      ValidationIssue.tooManyAttempts => l10n.errorTooManyAttempts,
      ValidationIssue.signInAgain => l10n.errorSignInAgain,
      ValidationIssue.signedOut => l10n.errorSignedOut,
      ValidationIssue.photoTooLarge => l10n.errorPhotoTooLarge,
      ValidationIssue.photoAccessDenied => l10n.errorPhotoAccess,
      ValidationIssue.photoUnreadable => l10n.errorPhotoUnreadable,
      ValidationIssue.notARoom => l10n.errorNotARoom,
      ValidationIssue.analysisLimitReached => l10n.errorAnalysisLimit,
    },
    LocationFailure(:final issue) => switch (issue) {
      LocationIssue.serviceDisabled => l10n.errorLocationOff,
      LocationIssue.permissionDenied => l10n.errorLocationDenied,
      LocationIssue.permissionDeniedForever => l10n.errorLocationDeniedForever,
    },
  };
}
