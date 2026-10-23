import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/room_design/domain/entities/palette_color.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';

/// A bright Scandinavian living room, 5 × 4 m.
const scandinavianLivingRoom = RoomAnalysis(
  roomType: RoomType.livingRoom,
  style: DesignStyle.scandinavian,
  secondaryStyle: DesignStyle.minimalist,
  palette: [
    PaletteColor(name: 'white', argb: 0xFFF5F5F5, share: 0.5),
    PaletteColor(name: 'warm beige', argb: 0xFFD8C3A5, share: 0.3),
    PaletteColor(name: 'light oak', argb: 0xFFC8A27A, share: 0.2),
  ],
  dimensions: RoomDimensions(widthM: 4, lengthM: 5),
  sizeConfidence: SizeConfidence.medium,
  summary: 'A bright living room with pale wood and soft textiles.',
);
