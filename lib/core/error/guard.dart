import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/core/result/result.dart';

/// Runs a data-layer [action] and converts thrown exceptions into a typed
/// [Failure]. Used by every repository implementation.
Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Ok(await action());
  } on AppException catch (e, stack) {
    AppLogger.error('Data layer error', e, stack);
    return Err(switch (e) {
      NetworkException() => NetworkFailure(e.message),
      ServerException() => ServerFailure(e.message),
      CacheException() => CacheFailure(e.message),
      NotFoundException() => NotFoundFailure(e.message),
      InvalidCredentialsException() => InvalidCredentialsFailure(e.message),
      ValidationException(:final issue) => ValidationFailure(issue, e.message),
      LocationException(:final issue) => LocationFailure(issue, e.message),
    });
  } on FormatException catch (e, stack) {
    AppLogger.error('Malformed data', e, stack);
    return Err(ServerFailure(e.message));
  } on Exception catch (e, stack) {
    AppLogger.error('Unexpected exception', e, stack);
    return Err(UnexpectedFailure(e.toString()));
  }
}
