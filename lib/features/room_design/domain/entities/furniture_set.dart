import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_slot.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_recommendation.dart';

/// A ready-made set of furniture for a room.
class FurnitureSet extends Equatable {
  const FurnitureSet({this.slots = const [], this.unfilled = const []});

  /// Slots that have at least one fitting product.
  final List<SlotRecommendation> slots;

  /// Slots for which nothing in the catalog fits this room.
  final List<FurnitureSlot> unfilled;

  bool get isEmpty => slots.isEmpty;

  /// The chosen product of every slot.
  List<SlotRecommendation> get chosen => slots;

  int get totalPrice => slots.fold(0, (sum, s) => sum + s.selected.totalPrice);

  int get pieceCount => slots.fold(0, (sum, s) => sum + s.selected.quantity);

  double get floorAreaM2 =>
      slots.fold(0.0, (sum, s) => sum + s.selected.floorAreaM2);

  /// Share of the floor covered by furniture (0..1).
  double floorUsage(RoomDimensions room) =>
      room.areaM2 == 0 ? 0 : floorAreaM2 / room.areaM2;

  FurnitureSet select(int slotIndex, int candidateIndex) => FurnitureSet(
    slots: [
      for (var i = 0; i < slots.length; i++)
        i == slotIndex ? slots[i].select(candidateIndex) : slots[i],
    ],
    unfilled: unfilled,
  );

  @override
  List<Object?> get props => [slots, unfilled];
}
