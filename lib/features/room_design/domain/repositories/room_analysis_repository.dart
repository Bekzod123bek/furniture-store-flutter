import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';

abstract interface class RoomAnalysisRepository {
  /// Works out the room type, style, colours and size from [photo]. The
  /// summary and colour names are written in [languageCode].
  Future<Result<RoomAnalysis>> analyze(
    RoomPhoto photo, {
    required String languageCode,
  });
}
