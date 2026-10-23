import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/room_design/data/datasources/room_analysis_remote_data_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_analysis_repository.dart';

class RoomAnalysisRepositoryImpl implements RoomAnalysisRepository {
  const RoomAnalysisRepositoryImpl(this._remote);

  final RoomAnalysisRemoteDataSource _remote;

  @override
  Future<Result<RoomAnalysis>> analyze(
    RoomPhoto photo, {
    required String languageCode,
  }) => guard(() => _remote.analyze(photo, languageCode: languageCode));
}
