import 'package:furniture_store/core/error/failures.dart';

/// Outcome of an operation that can fail in an expected way: either [Ok]
/// with a value or [Err] with a [Failure]. Use an exhaustive `switch`.
sealed class Result<T> {
  const Result();

  /// The value on success, otherwise `null`.
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  /// The failure on error, otherwise `null`.
  Failure? get failureOrNull => switch (this) {
    Ok() => null,
    Err(:final failure) => failure,
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
