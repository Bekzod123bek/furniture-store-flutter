import 'package:furniture_store/core/result/result.dart';

/// One application action. The presentation layer talks to the domain only
/// through use cases, never to repositories or data sources directly.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Parameter type for use cases that need no input.
final class NoParams {
  const NoParams();
}
