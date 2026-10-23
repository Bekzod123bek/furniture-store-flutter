import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/catalog/data/models/product_model.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';

import '../helpers/seed_catalog.dart';

void main() {
  group('sample catalog (tool/seed/catalog.json)', () {
    final products = SeedCatalog.products();

    test('every product can be read by the app', () {
      expect(products, hasLength(23));
      for (final p in products) {
        expect(p.images, isNotEmpty, reason: p.name);
        expect(p.colors, isNotEmpty, reason: p.name);
        expect(p.reviews, isNotEmpty, reason: p.name);
        expect(p.styles, isNotEmpty, reason: '${p.name} needs style tags');
        expect(p.dimensions.widthCm, greaterThan(0), reason: p.name);
        expect(p.price, greaterThan(0), reason: p.name);
      }
    });

    test('ids are unique and banners are readable', () {
      expect({for (final p in products) p.id}, hasLength(products.length));
      expect(SeedCatalog.banners(), hasLength(3));
    });

    test('discounts are computed from the old price', () {
      expect(SeedCatalog.byId('p1').discountPercent, 18);
      expect(SeedCatalog.byId('p2').discountPercent, 0);
    });

    test('floor space only counts floor-standing products', () {
      expect(SeedCatalog.byId('p19').floorAreaM2, 0, reason: 'pendant lamp');
      expect(SeedCatalog.byId('p1').floorAreaM2, closeTo(2.1 * 0.92, 0.05));
    });
  });

  group('ProductModel', () {
    Map<String, dynamic> valid() => {
      'name': 'Chair',
      'category': 'chair',
      'price': 100,
      'rating': 4,
      'reviewCount': 3,
      'popularity': 1,
      'material': 'Oak',
      'description': 'A chair',
      'widthCm': 40,
      'depthCm': 40,
      'heightCm': 80,
      'styles': ['modern', 'not-a-style'],
      'images': ['https://x/y.jpg'],
      'colors': [
        {'name': 'Oak', 'argb': 0xFFC8A27A},
      ],
      'reviews': [],
    };

    test('reads a minimal document and ignores unknown styles', () {
      final product = ProductModel.fromMap('c1', valid());
      expect(product.id, 'c1');
      expect(product.styles, {DesignStyle.modern});
      expect(product.floorStanding, isTrue);
      expect(product.oldPrice, isNull);
    });

    test('rejects broken documents', () {
      expect(
        () => ProductModel.fromMap('c1', {...valid(), 'category': 'spaceship'}),
        throwsFormatException,
      );
      expect(
        () => ProductModel.fromMap('c1', {...valid(), 'price': 'free'}),
        throwsFormatException,
      );
      expect(
        () => ProductModel.fromMap('c1', {...valid(), 'images': []}),
        throwsFormatException,
      );
      expect(
        () => ProductModel.fromMap('c1', {...valid(), 'colors': []}),
        throwsFormatException,
      );
    });
  });
}
