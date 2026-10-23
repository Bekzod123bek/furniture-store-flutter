import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_slot.dart';
import 'package:furniture_store/features/room_design/domain/entities/recommendation.dart';

/// The best few products for one [FurnitureSlot]. The user can swap between
/// [candidates]; [selectedIndex] says which one is in the set.
class SlotRecommendation extends Equatable {
  const SlotRecommendation({
    required this.slot,
    required this.candidates,
    this.selectedIndex = 0,
  }) : assert(selectedIndex >= 0);

  final FurnitureSlot slot;

  /// Best match first. Never empty.
  final List<Recommendation> candidates;
  final int selectedIndex;

  Recommendation get selected => candidates[selectedIndex];

  SlotRecommendation select(int index) => SlotRecommendation(
    slot: slot,
    candidates: candidates,
    selectedIndex: index.clamp(0, candidates.length - 1),
  );

  @override
  List<Object?> get props => [slot, candidates, selectedIndex];
}
