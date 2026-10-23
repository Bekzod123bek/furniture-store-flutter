import 'package:equatable/equatable.dart';

/// One dominant colour found in a room.
class PaletteColor extends Equatable {
  const PaletteColor({
    required this.name,
    required this.argb,
    required this.share,
  });

  /// Plain colour name such as "warm beige".
  final String name;

  /// 0xAARRGGBB.
  final int argb;

  /// Fraction of the visible room (0..1) in this colour.
  final double share;

  @override
  List<Object?> get props => [name, argb, share];
}
