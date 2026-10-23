import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_photo_picker.dart';

class PickRoomPhoto implements UseCase<RoomPhoto?, PhotoSource> {
  const PickRoomPhoto(this._picker);

  final RoomPhotoPicker _picker;

  @override
  Future<Result<RoomPhoto?>> call(PhotoSource params) => _picker.pick(params);
}
