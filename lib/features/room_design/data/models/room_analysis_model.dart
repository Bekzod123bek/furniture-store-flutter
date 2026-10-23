import 'package:furniture_store/core/utils/json_reader.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/room_design/domain/entities/palette_color.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';

/// Reads the JSON the vision model returns.
///
/// The model is asked for a fixed schema, but its output is still untrusted:
/// unknown styles fall back to safe defaults, sizes are clamped to a normal
/// room, and a malformed colour throws a [FormatException].
abstract final class RoomAnalysisModel {
  static const fallbackStyle = DesignStyle.modern;
  static const fallbackRoomType = RoomType.livingRoom;

  /// `true` when the model says the photo shows the inside of a room.
  static bool isRoom(Map<String, dynamic> map) =>
      JsonReader(map).booleanOr('isRoom', orElse: false);

  static RoomAnalysis fromMap(Map<String, dynamic> map) {
    final json = JsonReader(map);
    final style = DesignStyle.tryParse(json.optionalString('style'));
    final secondary = DesignStyle.tryParse(
      json.optionalString('secondaryStyle'),
    );
    final palette = _palette(json);
    if (palette.isEmpty) {
      throw const FormatException('The analysis has no colours');
    }

    return RoomAnalysis(
      roomType:
          RoomType.tryParse(json.optionalString('roomType')) ??
          fallbackRoomType,
      style: style ?? fallbackStyle,
      secondaryStyle: secondary == style ? null : secondary,
      palette: palette,
      dimensions: RoomDimensions(
        widthM: json.number('widthMeters'),
        lengthM: json.number('lengthMeters'),
      ).clamped(),
      sizeConfidence: SizeConfidence.values.firstWhere(
        (c) => c.name == json.optionalString('sizeConfidence'),
        orElse: () => SizeConfidence.low,
      ),
      summary: (json.optionalString('summary') ?? '').trim(),
    );
  }

  static List<PaletteColor> _palette(JsonReader json) {
    final colors = [
      for (final item in json.objects('palette'))
        PaletteColor(
          name: item.string('name').trim(),
          argb: parseHex(item.string('hex')),
          share: (item.optionalNumber('share') ?? 0).clamp(0.0, 1.0),
        ),
    ]..sort((a, b) => b.share.compareTo(a.share));
    return colors.take(5).toList();
  }

  /// Parses `#RRGGBB` (or `RRGGBB`) into an opaque 0xFFRRGGBB value.
  static int parseHex(String hex) {
    final cleaned = hex.trim().replaceFirst('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(cleaned)) {
      throw FormatException('"$hex" is not a #RRGGBB colour');
    }
    return 0xFF000000 | int.parse(cleaned, radix: 16);
  }
}
