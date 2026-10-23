import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/error/failures.dart';

/// Tells data sources who the signed-in user is, without depending on a
/// concrete auth SDK.
abstract interface class CurrentUserProvider {
  /// The signed-in user id, or `null` when nobody is signed in.
  String? get uid;
}

extension RequireUid on CurrentUserProvider {
  /// The signed-in user id. Throws when nobody is signed in.
  String get requireUid =>
      uid ?? (throw const ValidationException(ValidationIssue.signedOut));
}
