import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/room_design/data/models/room_analysis_model.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';

void main() {
  Map<String, dynamic> valid() => {
    'isRoom': true,
    'roomType': 'bedroom',
    'style': 'classic',
    'palette': [
      {'name': 'cream', 'hex': '#F5F0E1', 'share': 0.2},
      {'name': 'walnut', 'hex': '5D4037', 'share': 0.5},
    ],
    'widthMeters': 3.2,
    'lengthMeters': 4,
    'sizeConfidence': 'high',
    'summary': '  A calm bedroom.  ',
  };

  test('reads a real Gemini response (test/fixtures)', () {
    final json =
        jsonDecode(
              File(
                'test/fixtures/gemini_room_response.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    expect(RoomAnalysisModel.isRoom(json), isTrue);
    final room = RoomAnalysisModel.fromMap(json);
    expect(room.roomType, RoomType.livingRoom);
    expect(room.style, DesignStyle.scandinavian);
    expect(room.secondaryStyle, DesignStyle.minimalist);
    expect(room.palette, hasLength(3));
    expect(room.palette.first.name, 'white');
    expect(room.palette.first.argb, 0xFFFFFFFF);
    expect(room.dimensions, const RoomDimensions(widthM: 3.6, lengthM: 4.5));
    expect(room.sizeConfidence, SizeConfidence.medium);
    expect(room.summary, isNotEmpty);
  });

  test('parses colours with or without #, sorts them by share, trims text', () {
    final room = RoomAnalysisModel.fromMap(valid());
    expect(room.palette.map((c) => c.name), ['walnut', 'cream']);
    expect(room.palette.first.argb, 0xFF5D4037);
    expect(room.palette.map((c) => c.share), [
      0.5,
      0.2,
    ], reason: 'fractions stay');
    expect(room.dimensions.lengthM, 4.0, reason: 'int is accepted');
    expect(room.summary, 'A calm bedroom.');
  });

  test('unknown room type and style fall back to safe defaults', () {
    final room = RoomAnalysisModel.fromMap({
      ...valid(),
      'roomType': 'spaceship',
      'style': 'baroque',
      'secondaryStyle': 'also-unknown',
    });
    expect(room.roomType, RoomAnalysisModel.fallbackRoomType);
    expect(room.style, RoomAnalysisModel.fallbackStyle);
    expect(room.secondaryStyle, isNull);
  });

  test('secondary style equal to the main style is dropped', () {
    final room = RoomAnalysisModel.fromMap({
      ...valid(),
      'secondaryStyle': 'classic',
    });
    expect(room.secondaryStyle, isNull);
  });

  test('absurd sizes are clamped to a normal room', () {
    final room = RoomAnalysisModel.fromMap({
      ...valid(),
      'widthMeters': 0.1,
      'lengthMeters': 250,
    });
    expect(room.dimensions.widthM, RoomDimensions.minSideM);
    expect(room.dimensions.lengthM, RoomDimensions.maxSideM);
  });

  test('missing confidence means low', () {
    final json = {...valid()}..remove('sizeConfidence');
    expect(RoomAnalysisModel.fromMap(json).sizeConfidence, SizeConfidence.low);
  });

  test('broken output is rejected', () {
    expect(
      () => RoomAnalysisModel.fromMap({...valid(), 'palette': []}),
      throwsFormatException,
    );
    expect(
      () => RoomAnalysisModel.fromMap({
        ...valid(),
        'palette': [
          {'name': 'x', 'hex': 'red', 'share': 1},
        ],
      }),
      throwsFormatException,
    );
    expect(
      () => RoomAnalysisModel.fromMap({...valid(), 'widthMeters': 'wide'}),
      throwsFormatException,
    );
    expect(RoomAnalysisModel.isRoom({...valid(), 'isRoom': false}), isFalse);
    expect(RoomAnalysisModel.isRoom({'summary': 'x'}), isFalse);
  });
}
