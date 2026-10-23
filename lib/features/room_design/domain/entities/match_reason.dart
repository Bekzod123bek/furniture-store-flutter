import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';

/// Why a product was chosen for a room. Data only; the UI writes the
/// sentence in the user's language.
sealed class MatchReason extends Equatable {
  const MatchReason();
}

/// The product has the room's main style.
final class SameStyleReason extends MatchReason {
  const SameStyleReason(this.style);

  final DesignStyle style;

  @override
  List<Object?> get props => [style];
}

/// The product has the room's second style.
final class SecondaryStyleReason extends MatchReason {
  const SecondaryStyleReason(this.style);

  final DesignStyle style;

  @override
  List<Object?> get props => [style];
}

/// The product's style pairs well with the room's [style].
final class RelatedStyleReason extends MatchReason {
  const RelatedStyleReason(this.style);

  final DesignStyle style;

  @override
  List<Object?> get props => [style];
}

/// The chosen colour goes with the room's main [roomTones].
final class ColorReason extends MatchReason {
  const ColorReason(this.colorName, this.roomTones);

  final String colorName;
  final List<String> roomTones;

  @override
  List<Object?> get props => [colorName, roomTones];
}

/// The product is [widthCm] wide and covers [floorPercent]% of the floor.
final class SizeReason extends MatchReason {
  const SizeReason({required this.widthCm, required this.floorPercent});

  final int widthCm;
  final int floorPercent;

  @override
  List<Object?> get props => [widthCm, floorPercent];
}

/// Hangs on the wall or ceiling, or stands on a table.
final class NoFloorSpaceReason extends MatchReason {
  const NoFloorSpaceReason();

  @override
  List<Object?> get props => [];
}
