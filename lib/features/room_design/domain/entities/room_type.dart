import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_slot.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_kind.dart';

enum RoomType {
  livingRoom,
  bedroom,
  diningRoom,
  office;

  /// The furniture a room of this type needs, most important first.
  List<FurnitureSlot> get slots => switch (this) {
    RoomType.livingRoom => const [
      FurnitureSlot(kind: SlotKind.sofa, category: ProductCategory.sofa),
      FurnitureSlot(
        kind: SlotKind.armchair,
        category: ProductCategory.armchair,
      ),
      FurnitureSlot(
        kind: SlotKind.coffeeTable,
        category: ProductCategory.table,
        maxWidthCm: 100,
      ),
      FurnitureSlot(kind: SlotKind.lighting, category: ProductCategory.lamp),
      FurnitureSlot(kind: SlotKind.storage, category: ProductCategory.storage),
    ],
    RoomType.bedroom => const [
      FurnitureSlot(kind: SlotKind.bed, category: ProductCategory.bed),
      FurnitureSlot(kind: SlotKind.storage, category: ProductCategory.storage),
      FurnitureSlot(kind: SlotKind.lighting, category: ProductCategory.lamp),
      FurnitureSlot(
        kind: SlotKind.readingChair,
        category: ProductCategory.armchair,
      ),
    ],
    RoomType.diningRoom => const [
      FurnitureSlot(
        kind: SlotKind.diningTable,
        category: ProductCategory.table,
        minWidthCm: 120,
        minDepthCm: 80,
      ),
      FurnitureSlot(
        kind: SlotKind.diningChairs,
        category: ProductCategory.chair,
        quantity: 4,
        minHeightCm: 80,
      ),
      FurnitureSlot(kind: SlotKind.lighting, category: ProductCategory.lamp),
      FurnitureSlot(kind: SlotKind.storage, category: ProductCategory.storage),
    ],
    RoomType.office => const [
      FurnitureSlot(
        kind: SlotKind.desk,
        category: ProductCategory.table,
        minWidthCm: 100,
        maxWidthCm: 170,
      ),
      FurnitureSlot(
        kind: SlotKind.deskChair,
        category: ProductCategory.chair,
        minHeightCm: 80,
      ),
      FurnitureSlot(kind: SlotKind.lighting, category: ProductCategory.lamp),
      FurnitureSlot(kind: SlotKind.shelving, category: ProductCategory.storage),
    ],
  };

  static RoomType? tryParse(String? name) {
    for (final type in values) {
      if (type.name == name) return type;
    }
    return null;
  }
}
