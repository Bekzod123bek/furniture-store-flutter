import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_analysis_repository.dart';

class AnalyzeRoom implements UseCase<RoomAnalysis, AnalyzeRoomParams> {
  const AnalyzeRoom(this._repository);

  final RoomAnalysisRepository _repository;

  @override
  Future<Result<RoomAnalysis>> call(AnalyzeRoomParams params) =>
      _repository.analyze(params.photo, languageCode: params.languageCode);
}

class AnalyzeRoomParams {
  const AnalyzeRoomParams(this.photo, {required this.languageCode});

  final RoomPhoto photo;
  final String languageCode;
}
