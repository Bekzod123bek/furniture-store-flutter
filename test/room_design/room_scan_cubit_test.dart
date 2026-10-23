import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_products.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';
import 'package:furniture_store/features/room_design/domain/usecases/analyze_room.dart';
import 'package:furniture_store/features/room_design/domain/usecases/pick_room_photo.dart';
import 'package:furniture_store/features/room_design/domain/usecases/recommend_furniture.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_cubit.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_state.dart';

import '../helpers/fakes.dart';
import '../helpers/rooms.dart';
import '../helpers/seed_catalog.dart';

void main() {
  late FakeRoomPhotoPicker picker;
  late FakeRoomAnalysisRepository analysis;
  late FakeCatalogRepository catalog;
  late RoomScanCubit cubit;

  setUp(() {
    picker = FakeRoomPhotoPicker();
    analysis = FakeRoomAnalysisRepository(scandinavianLivingRoom);
    catalog = FakeCatalogRepository(SeedCatalog.products());
    cubit = RoomScanCubit(
      pickRoomPhoto: PickRoomPhoto(picker),
      analyzeRoom: AnalyzeRoom(analysis),
      getProducts: GetProducts(catalog),
      recommendFurniture: const RecommendFurniture(),
    );
  });
  tearDown(() => cubit.close());

  test('photo → analysis in the user language → furniture set', () async {
    final states = <RoomScanStatus>[];
    final sub = cubit.stream.listen((s) => states.add(s.status));
    await cubit.pickPhoto(PhotoSource.gallery, languageCode: 'ru');
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [RoomScanStatus.analyzing, RoomScanStatus.ready]);
    expect(analysis.lastLanguage, 'ru');
    expect(cubit.state.analysis, scandinavianLivingRoom);
    expect(cubit.state.furnitureSet.slots, isNotEmpty);
    expect(cubit.state.photo, isNotNull);
  });

  test('cancelling the picker changes nothing', () async {
    picker.photo = null;
    await cubit.pickPhoto(PhotoSource.camera, languageCode: 'uz');
    expect(cubit.state, const RoomScanState());
    expect(analysis.calls, 0);
  });

  test('a failed analysis can be retried with the same photo', () async {
    analysis.failure = const ValidationFailure(ValidationIssue.notARoom);
    await cubit.pickPhoto(PhotoSource.gallery, languageCode: 'uz');
    expect(cubit.state.status, RoomScanStatus.failure);
    expect(cubit.state.failure, isA<ValidationFailure>());

    analysis.failure = null;
    await cubit.retry();
    expect(cubit.state.status, RoomScanStatus.ready);
    expect(analysis.calls, 2);
    expect(analysis.lastLanguage, 'uz', reason: 'retry keeps the language');
  });

  test('a catalog error is reported', () async {
    catalog.failure = const NetworkFailure();
    await cubit.pickPhoto(PhotoSource.gallery, languageCode: 'uz');
    expect(cubit.state.status, RoomScanStatus.failure);
    expect(cubit.state.failure, const NetworkFailure());
  });

  test('corrections rebuild the set at once', () async {
    await cubit.pickPhoto(PhotoSource.gallery, languageCode: 'en');
    final before = cubit.state.furnitureSet;

    cubit.setStyle(DesignStyle.industrial);
    expect(cubit.state.analysis!.style, DesignStyle.industrial);
    expect(cubit.state.furnitureSet, isNot(before));

    cubit.setRoomType(RoomType.bedroom);
    expect(cubit.state.furnitureSet.slots.first.slot.kind.name, 'bed');

    cubit.setDimensions(const RoomDimensions(widthM: 0.5, lengthM: 3));
    expect(
      cubit.state.analysis!.dimensions.widthM,
      RoomDimensions.minSideM,
      reason: 'clamped',
    );

    cubit.selectCandidate(0, 1);
    expect(cubit.state.furnitureSet.slots.first.selectedIndex, 1);

    cubit.reset();
    expect(cubit.state, const RoomScanState());
  });
}
