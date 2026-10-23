import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/room_design/domain/entities/palette_color.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';

/// How sure the model is about the room size it estimated from the photo.
enum SizeConfidence { low, medium, high }

/// What we learned about a room from its photo. The user can correct any
/// field, so this is also the input of the furniture matcher.
class RoomAnalysis extends Equatable {
  const RoomAnalysis({
    required this.roomType,
    required this.style,
    required this.palette,
    required this.dimensions,
    required this.summary,
    this.secondaryStyle,
    this.sizeConfidence = SizeConfidence.low,
  });

  final RoomType roomType;
  final DesignStyle style;
  final DesignStyle? secondaryStyle;

  /// Dominant colours, largest share first.
  final List<PaletteColor> palette;
  final RoomDimensions dimensions;
  final SizeConfidence sizeConfidence;
  final String summary;

  RoomAnalysis copyWith({
    RoomType? roomType,
    DesignStyle? style,
    RoomDimensions? dimensions,
  }) => RoomAnalysis(
    roomType: roomType ?? this.roomType,
    style: style ?? this.style,
    secondaryStyle: secondaryStyle == (style ?? this.style)
        ? null
        : secondaryStyle,
    palette: palette,
    dimensions: dimensions ?? this.dimensions,
    sizeConfidence: dimensions == null ? sizeConfidence : SizeConfidence.high,
    summary: summary,
  );

  @override
  List<Object?> get props => [
    roomType,
    style,
    secondaryStyle,
    palette,
    dimensions,
    sizeConfidence,
    summary,
  ];
}
