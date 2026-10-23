import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/domain/usecases/filter_products.dart';

import '../helpers/seed_catalog.dart';

void main() {
  final products = SeedCatalog.products();
  const filter = FilterProducts();

  test('search finds a category by its name in the user language', () {
    const names = {
      ProductCategory.sofa: ['Divanlar'],
      ProductCategory.lamp: ['Светильники'],
    };
    final sofas = filter(
      products,
      const ProductFilter(query: 'divan'),
      categoryNames: names,
    );
    expect(sofas, isNotEmpty);
    expect(sofas.every((p) => p.category == ProductCategory.sofa), isTrue);

    final lamps = filter(
      products,
      const ProductFilter(query: 'светильник'),
      categoryNames: names,
    );
    expect(lamps.every((p) => p.category == ProductCategory.lamp), isTrue);
    expect(lamps, isNotEmpty);
  });

  test('without names the enum name still matches', () {
    expect(filter(products, const ProductFilter(query: 'storage')), isNotEmpty);
  });
}
