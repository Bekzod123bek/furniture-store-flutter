import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';

/// Lets the user take or choose a photo of their room.
abstract interface class RoomPhotoPicker {
  /// The chosen photo, or `Ok(null)` when the user cancelled.
  Future<Result<RoomPhoto?>> pick(PhotoSource source);
}
