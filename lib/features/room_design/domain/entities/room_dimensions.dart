import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Floor size of a room in metres.
class RoomDimensions extends Equatable {
  const RoomDimensions({required this.widthM, required this.lengthM});

  /// Smallest and largest side accepted. Anything outside is not a normal
  /// room, or the estimate is wrong.
  static const minSideM = 1.5;
  static const maxSideM = 15.0;

  final double widthM;
  final double lengthM;

  double get areaM2 => widthM * lengthM;

  /// Length of the longest wall in centimetres.
  double get longestWallCm => math.max(widthM, lengthM) * 100;

  /// Same room with both sides forced into the accepted range.
  RoomDimensions clamped() => RoomDimensions(
    widthM: widthM.clamp(minSideM, maxSideM),
    lengthM: lengthM.clamp(minSideM, maxSideM),
  );

  String get label =>
      '${widthM.toStringAsFixed(1)} × ${lengthM.toStringAsFixed(1)} m';

  @override
  List<Object?> get props => [widthM, lengthM];
}
