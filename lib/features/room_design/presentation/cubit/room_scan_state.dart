import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_set.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';

enum RoomScanStatus { idle, analyzing, ready, failure }

class RoomScanState extends Equatable {
  const RoomScanState({
    this.status = RoomScanStatus.idle,
    this.photo,
    this.analysis,
    this.furnitureSet = const FurnitureSet(),
    this.failure,
  });

  final RoomScanStatus status;
  final RoomPhoto? photo;
  final RoomAnalysis? analysis;
  final FurnitureSet furnitureSet;
  final Failure? failure;

  RoomScanState copyWith({
    RoomScanStatus? status,
    RoomPhoto? photo,
    RoomAnalysis? analysis,
    FurnitureSet? furnitureSet,
    Failure? Function()? failure,
  }) => RoomScanState(
    status: status ?? this.status,
    photo: photo ?? this.photo,
    analysis: analysis ?? this.analysis,
    furnitureSet: furnitureSet ?? this.furnitureSet,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, photo, analysis, furnitureSet, failure];
}
