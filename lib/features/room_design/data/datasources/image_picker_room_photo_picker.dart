import 'package:flutter/services.dart';
import 'package:furniture_store/core/error/exceptions.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_photo_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Picks photos with the `image_picker` plugin. Photos are scaled down to
/// 1280 px: that is plenty for colours and style, and keeps the upload small.
class ImagePickerRoomPhotoPicker implements RoomPhotoPicker {
  ImagePickerRoomPhotoPicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  static const _maxBytes = 10 * 1024 * 1024;

  final ImagePicker _picker;

  @override
  Future<Result<RoomPhoto?>> pick(PhotoSource source) => guard(() async {
    final XFile? file;
    try {
      file = await _picker.pickImage(
        source: switch (source) {
          PhotoSource.camera => ImageSource.camera,
          PhotoSource.gallery => ImageSource.gallery,
        },
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
    } on PlatformException catch (e) {
      if (e.code.contains('access_denied')) {
        throw ValidationException(ValidationIssue.photoAccessDenied, e.code);
      }
      throw ServerException('${e.code}: ${e.message}');
    }
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    if (bytes.length > _maxBytes) {
      throw const ValidationException(ValidationIssue.photoTooLarge);
    }
    return RoomPhoto(bytes: bytes, mimeType: _mimeType(file));
  });

  static String _mimeType(XFile file) {
    final declared = file.mimeType;
    if (declared != null && declared.startsWith('image/')) return declared;
    final name = file.name.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    if (name.endsWith('.heic')) return 'image/heic';
    if (name.endsWith('.heif')) return 'image/heif';
    return 'image/jpeg';
  }
}
