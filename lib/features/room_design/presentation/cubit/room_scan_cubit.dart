import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_products.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';
import 'package:furniture_store/features/room_design/domain/usecases/analyze_room.dart';
import 'package:furniture_store/features/room_design/domain/usecases/pick_room_photo.dart';
import 'package:furniture_store/features/room_design/domain/usecases/recommend_furniture.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_state.dart';

/// Photo → analysis → furniture set. After the analysis the user can fix the
/// room type, style or size, and the set is rebuilt immediately.
class RoomScanCubit extends Cubit<RoomScanState> {
  RoomScanCubit({
    required PickRoomPhoto pickRoomPhoto,
    required AnalyzeRoom analyzeRoom,
    required GetProducts getProducts,
    required RecommendFurniture recommendFurniture,
  }) : _pick = pickRoomPhoto,
       _analyze = analyzeRoom,
       _getProducts = getProducts,
       _recommend = recommendFurniture,
       super(const RoomScanState());

  final PickRoomPhoto _pick;
  final AnalyzeRoom _analyze;
  final GetProducts _getProducts;
  final RecommendFurniture _recommend;

  List<Product> _catalog = const [];

  /// Language of the room summary and colour names.
  String _languageCode = 'uz';

  /// Lets the user pick a photo and analyses it. [languageCode] decides the
  /// language of the room description.
  Future<void> pickPhoto(
    PhotoSource source, {
    required String languageCode,
  }) async {
    _languageCode = languageCode;
    if (state.status == RoomScanStatus.analyzing) return;
    final picked = await _pick(source);
    if (isClosed) return;
    switch (picked) {
      case Err(:final failure):
        emit(
          state.copyWith(
            status: RoomScanStatus.failure,
            failure: () => failure,
          ),
        );
      case Ok(value: null):
        return; // The user cancelled.
      case Ok(:final value?):
        await _analyzePhoto(value);
    }
  }

  /// Tries the analysis again with the same photo.
  Future<void> retry() async {
    final photo = state.photo;
    if (photo == null) {
      emit(const RoomScanState());
      return;
    }
    await _analyzePhoto(photo);
  }

  Future<void> _analyzePhoto(RoomPhoto photo) async {
    emit(RoomScanState(status: RoomScanStatus.analyzing, photo: photo));

    final analysis = await _analyze(
      AnalyzeRoomParams(photo, languageCode: _languageCode),
    );
    if (isClosed) return;
    final RoomAnalysis room;
    switch (analysis) {
      case Err(:final failure):
        emit(
          state.copyWith(
            status: RoomScanStatus.failure,
            failure: () => failure,
          ),
        );
        return;
      case Ok(:final value):
        room = value;
    }

    final products = await _getProducts(const GetProductsParams());
    if (isClosed) return;
    switch (products) {
      case Err(:final failure):
        emit(
          state.copyWith(
            status: RoomScanStatus.failure,
            failure: () => failure,
          ),
        );
        return;
      case Ok(:final value):
        _catalog = value;
    }

    emit(
      state.copyWith(
        status: RoomScanStatus.ready,
        analysis: room,
        furnitureSet: _recommend(_catalog, room),
        failure: () => null,
      ),
    );
  }

  void setRoomType(RoomType type) =>
      _update((room) => room.copyWith(roomType: type));

  void setStyle(DesignStyle style) =>
      _update((room) => room.copyWith(style: style));

  void setDimensions(RoomDimensions dimensions) =>
      _update((room) => room.copyWith(dimensions: dimensions.clamped()));

  void _update(RoomAnalysis Function(RoomAnalysis room) change) {
    final current = state.analysis;
    if (current == null) return;
    final next = change(current);
    emit(
      state.copyWith(analysis: next, furnitureSet: _recommend(_catalog, next)),
    );
  }

  /// Swaps the product in one slot of the set.
  void selectCandidate(int slotIndex, int candidateIndex) => emit(
    state.copyWith(
      furnitureSet: state.furnitureSet.select(slotIndex, candidateIndex),
    ),
  );

  void reset() => emit(const RoomScanState());
}
