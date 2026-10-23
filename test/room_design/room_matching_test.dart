import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/room_design/domain/entities/palette_color.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_kind.dart';
import 'package:furniture_store/features/room_design/domain/services/color_harmony.dart';
import 'package:furniture_store/features/room_design/domain/services/fit_checker.dart';
import 'package:furniture_store/features/room_design/domain/services/style_matcher.dart';
import 'package:furniture_store/features/room_design/domain/usecases/recommend_furniture.dart';

import '../helpers/rooms.dart';
import '../helpers/seed_catalog.dart';

const _white = 0xFFF5F5F5;
const _black = 0xFF1F1F1F;
const _beige = 0xFFD8C3A5;
const _blue = 0xFF22304A;
const _orange = 0xFFD0562E;
const _green = 0xFF1F5E4E;

void main() {
  final products = SeedCatalog.products();
  const recommend = RecommendFurniture();

  group('ColorHarmony', () {
    test('neutrals go with everything', () {
      expect(ColorHarmony.isNeutral(_white), isTrue);
      expect(ColorHarmony.isNeutral(_black), isTrue);
      expect(ColorHarmony.isNeutral(_orange), isFalse);
      expect(ColorHarmony.pairScore(_white, _orange), 0.85);
      expect(ColorHarmony.pairScore(_blue, _black), 0.85);
    });

    test('neighbouring hues beat clashing ones', () {
      // beige and orange are close on the wheel, green is far from both
      expect(ColorHarmony.pairScore(_beige, _orange), greaterThan(0.7));
      expect(ColorHarmony.pairScore(_orange, _green), lessThan(0.6));
      expect(ColorHarmony.pairScore(_orange, _orange), 1);
    });

    test('the score changes smoothly with the hue distance', () {
      // Same saturation and lightness, hue turned by 10 degrees each step.
      int hue(double degrees) {
        final h = degrees / 60;
        final x = 1 - (h % 2 - 1).abs();
        final (r, g, b) = switch (h.floor()) {
          0 => (1.0, x, 0.0),
          1 => (x, 1.0, 0.0),
          2 => (0.0, 1.0, x),
          3 => (0.0, x, 1.0),
          4 => (x, 0.0, 1.0),
          _ => (1.0, 0.0, x),
        };
        int c(double v) => (v * 255).round();
        return 0xFF000000 |
            c(r * 0.8 + 0.1) << 16 |
            c(g * 0.8 + 0.1) << 8 |
            c(b * 0.8 + 0.1);
      }

      var previous = ColorHarmony.pairScore(hue(0), hue(0));
      for (var degrees = 10; degrees <= 180; degrees += 10) {
        final score = ColorHarmony.pairScore(hue(0), hue(degrees.toDouble()));
        expect((score - previous).abs(), lessThan(0.2), reason: 'at $degrees°');
        previous = score;
      }
    });

    test('opposite colours work as an accent', () {
      const teal = 0xFF1F8E9E;
      const red = 0xFFB8362E;
      expect(ColorHarmony.pairScore(teal, red), greaterThan(0.7));
    });

    test('score is weighted by how much of the room a colour covers', () {
      const mostlyGreen = [
        PaletteColor(name: 'green', argb: _green, share: 0.9),
        PaletteColor(name: 'orange', argb: _orange, share: 0.1),
      ];
      const mostlyOrange = [
        PaletteColor(name: 'green', argb: _green, share: 0.1),
        PaletteColor(name: 'orange', argb: _orange, share: 0.9),
      ];
      expect(
        ColorHarmony.paletteScore(_green, mostlyGreen),
        greaterThan(ColorHarmony.paletteScore(_green, mostlyOrange)),
      );
      expect(ColorHarmony.paletteScore(_green, const []), 0.5);
    });

    test('bestColor picks the variant that suits the palette', () {
      final sofa = SeedCatalog.byId('p1'); // Emerald, Navy, Rose
      const greenRoom = [
        PaletteColor(name: 'sage', argb: 0xFF7A9A6B, share: 1),
      ];
      expect(ColorHarmony.bestColor(sofa, greenRoom).color.name, 'Emerald');
      final sand = SeedCatalog.byId('p4'); // Sky, Sand
      const warmRoom = [PaletteColor(name: 'beige', argb: _beige, share: 1)];
      expect(ColorHarmony.bestColor(sand, warmRoom).color.name, 'Sand');
    });
  });

  group('StyleMatcher', () {
    final scandi = SeedCatalog.byId('p4'); // scandinavian, modern, minimalist

    test('same style scores 1, secondary 0.75, related 0.5, other low', () {
      expect(StyleMatcher.score(scandi, scandinavianLivingRoom), 1);
      final secondary = scandinavianLivingRoom.copyWith(
        style: DesignStyle.classic,
      );
      // p4 has no classic tag; the secondary style (minimalist) is on p4
      expect(StyleMatcher.score(scandi, secondary), 0.75);
      final industrial = SeedCatalog.byId('p18');
      expect(StyleMatcher.score(industrial, scandinavianLivingRoom), 0.5);
      final classic = SeedCatalog.byId('p16'); // classic only
      final noSecondary = scandinavianLivingRoom.copyWith(
        style: DesignStyle.industrial,
      );
      expect(StyleMatcher.score(classic, noSecondary), 0.15);
    });
  });

  group('FitChecker', () {
    const small = RoomDimensions(widthM: 2.5, lengthM: 3);
    const big = RoomDimensions(widthM: 5, lengthM: 6);

    test('big furniture does not fit a small room', () {
      final bed = SeedCatalog.byId('p16'); // 180 × 200
      expect(FitChecker.fits(bed, small), isFalse);
      expect(FitChecker.fits(bed, big), isTrue);
    });

    test('things that hang or sit on a table always fit', () {
      expect(FitChecker.fits(SeedCatalog.byId('p19'), small), isTrue);
      expect(FitChecker.sizeScore(SeedCatalog.byId('p19'), small), 1);
    });

    test('size score drops as a piece takes more of the floor', () {
      final sofa = SeedCatalog.byId('p1');
      expect(FitChecker.sizeScore(sofa, big), 1);
      expect(
        FitChecker.sizeScore(sofa, const RoomDimensions(widthM: 3, lengthM: 4)),
        lessThan(1),
      );
      expect(FitChecker.floorBudgetM2(big), closeTo(30 * 0.35, 0.001));
    });

    test('room size is clamped to a normal room', () {
      final room = const RoomDimensions(widthM: 0.2, lengthM: 80).clamped();
      expect(room.widthM, RoomDimensions.minSideM);
      expect(room.lengthM, RoomDimensions.maxSideM);
    });
  });

  group('RecommendFurniture', () {
    test('fills every slot of a living room with matching categories', () {
      final set = recommend(products, scandinavianLivingRoom);
      expect(set.slots.map((s) => s.slot.category), [
        ProductCategory.sofa,
        ProductCategory.armchair,
        ProductCategory.table,
        ProductCategory.lamp,
        ProductCategory.storage,
      ]);
      expect(set.unfilled, isEmpty);
      for (final slot in set.slots) {
        expect(slot.candidates, isNotEmpty);
        expect(slot.candidates.length, lessThanOrEqualTo(3));
        expect(slot.selectedIndex, 0);
        // best first
        for (var i = 1; i < slot.candidates.length; i++) {
          expect(
            slot.candidates[i].score,
            lessThanOrEqualTo(slot.candidates[i - 1].score),
          );
        }
        expect(slot.selected.reasons, isNotEmpty);
      }
    });

    test(
      'a scandinavian room gets scandinavian furniture in matching colours',
      () {
        final set = recommend(products, scandinavianLivingRoom);
        final sofa = set.slots.first.selected;
        expect(sofa.product.styles, contains(DesignStyle.scandinavian));
        expect(sofa.color.name, 'Sand', reason: 'beige/white room');
        expect(sofa.styleScore, 1);
        expect(sofa.colorScore, greaterThan(0.8));
      },
    );

    test('the style of the room changes the choice', () {
      final scandi = recommend(products, scandinavianLivingRoom);
      final industrial = recommend(
        products,
        scandinavianLivingRoom.copyWith(style: DesignStyle.industrial),
      );
      expect(
        industrial.slots.first.selected.product,
        isNot(scandi.slots.first.selected.product),
      );
      expect(
        industrial.slots.first.selected.product.styles,
        contains(DesignStyle.industrial),
      );
    });

    test('only products that fit the room are suggested', () {
      const tiny = RoomDimensions(widthM: 2.5, lengthM: 2.5);
      final room = scandinavianLivingRoom.copyWith(dimensions: tiny);
      final set = recommend(products, room);
      for (final s in set.slots) {
        for (final c in s.candidates) {
          expect(
            FitChecker.fits(c.product, tiny),
            isTrue,
            reason: c.product.name,
          );
        }
      }
      expect(
        set.floorUsage(tiny),
        lessThanOrEqualTo(FitChecker.maxFloorUsage + 0.02),
      );
    });

    test('a bedroom in a tiny room has no bed that fits', () {
      final room = scandinavianLivingRoom.copyWith(
        roomType: RoomType.bedroom,
        dimensions: const RoomDimensions(widthM: 2, lengthM: 2.5),
      );
      final set = recommend(products, room);
      expect(set.unfilled.map((s) => s.kind), contains(SlotKind.bed));
      expect(
        set.slots.any((s) => s.slot.category == ProductCategory.bed),
        isFalse,
      );
    });

    test('a dining room gets four chairs and a real dining table', () {
      final room = scandinavianLivingRoom.copyWith(
        roomType: RoomType.diningRoom,
      );
      final set = recommend(products, room);
      final table = set.slots.first.selected.product;
      expect(table.category, ProductCategory.table);
      expect(table.dimensions.widthCm, greaterThanOrEqualTo(120));
      expect(
        table.dimensions.depthCm,
        greaterThanOrEqualTo(80),
        reason: 'not a desk',
      );
      final chairs = set.slots[1];
      expect(chairs.selected.quantity, 4);
      expect(chairs.selected.totalPrice, chairs.selected.product.price * 4);
      for (final c in chairs.candidates) {
        expect(
          c.product.dimensions.heightCm,
          greaterThanOrEqualTo(80),
          reason: 'no bar stools',
        );
      }
    });

    test('a home office gets a desk, not a dining table', () {
      final room = scandinavianLivingRoom.copyWith(
        roomType: RoomType.office,
        dimensions: const RoomDimensions(widthM: 3, lengthM: 3.5),
      );
      final desk = recommend(products, room).slots.first.selected.product;
      expect(desk.name, 'Studio Work Desk');
    });

    test('totals follow the selected products and swapping works', () {
      final set = recommend(products, scandinavianLivingRoom);
      final first = set.slots.first;
      expect(
        set.totalPrice,
        set.slots.fold<int>(0, (s, e) => s + e.selected.totalPrice),
      );
      expect(set.pieceCount, 5);

      final swapped = set.select(0, 1);
      expect(swapped.slots.first.selected, first.candidates[1]);
      expect(swapped.slots[1], set.slots[1]);
      expect(
        swapped.totalPrice - set.totalPrice,
        first.candidates[1].totalPrice - first.candidates[0].totalPrice,
      );
      expect(
        set.select(0, 99).slots.first.selectedIndex,
        first.candidates.length - 1,
      );
    });

    test('an empty catalog gives an empty set with every slot unfilled', () {
      final set = recommend(const [], scandinavianLivingRoom);
      expect(set.isEmpty, isTrue);
      expect(set.unfilled, hasLength(5));
      expect(set.totalPrice, 0);
    });

    test('is deterministic', () {
      expect(
        recommend(products, scandinavianLivingRoom),
        recommend(products.reversed.toList(), scandinavianLivingRoom),
      );
    });
  });
}
