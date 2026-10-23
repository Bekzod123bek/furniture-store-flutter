import 'package:furniture_store/features/catalog/presentation/l10n/catalog_labels.dart';
import 'package:furniture_store/features/room_design/domain/entities/match_reason.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_kind.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

extension RoomTypeLabel on RoomType {
  String label(AppLocalizations l10n) => switch (this) {
    RoomType.livingRoom => l10n.roomTypeLiving,
    RoomType.bedroom => l10n.roomTypeBedroom,
    RoomType.diningRoom => l10n.roomTypeDining,
    RoomType.office => l10n.roomTypeOffice,
  };
}

extension SlotKindLabel on SlotKind {
  String label(AppLocalizations l10n) => switch (this) {
    SlotKind.sofa => l10n.slotSofa,
    SlotKind.armchair => l10n.slotArmchair,
    SlotKind.coffeeTable => l10n.slotCoffeeTable,
    SlotKind.lighting => l10n.slotLighting,
    SlotKind.storage => l10n.slotStorage,
    SlotKind.bed => l10n.slotBed,
    SlotKind.readingChair => l10n.slotReadingChair,
    SlotKind.diningTable => l10n.slotDiningTable,
    SlotKind.diningChairs => l10n.slotDiningChairs,
    SlotKind.desk => l10n.slotDesk,
    SlotKind.deskChair => l10n.slotDeskChair,
    SlotKind.shelving => l10n.slotShelving,
  };
}

extension MatchReasonText on MatchReason {
  String text(AppLocalizations l10n) => switch (this) {
    SameStyleReason(:final style) => l10n.reasonSameStyle(style.label(l10n)),
    SecondaryStyleReason(:final style) => l10n.reasonSecondaryStyle(
      style.label(l10n),
    ),
    RelatedStyleReason(:final style) => l10n.reasonRelatedStyle(
      style.label(l10n),
    ),
    ColorReason(:final colorName, :final roomTones) => switch (roomTones) {
      [] => l10n.reasonColorPlain(colorName),
      [final only] => l10n.reasonColor(colorName, only),
      [final first, final second, ...] => l10n.reasonColor(
        colorName,
        l10n.reasonTonesJoin(first, second),
      ),
    },
    SizeReason(:final widthCm, :final floorPercent) => l10n.reasonSize(
      '$widthCm',
      '$floorPercent',
    ),
    NoFloorSpaceReason() => l10n.reasonNoFloor,
  };
}
