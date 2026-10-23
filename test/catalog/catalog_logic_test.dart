import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/domain/usecases/catalog_summary.dart';
import 'package:furniture_store/features/catalog/domain/usecases/filter_products.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_banners.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_products.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_related_products.dart';
import 'package:furniture_store/features/catalog/presentation/cubit/catalog_cubit.dart';

import '../helpers/fakes.dart';
import '../helpers/seed_catalog.dart';

void main() {
  final products = SeedCatalog.products();
  const filterProducts = FilterProducts();

  group('FilterProducts', () {
    test('filters by category, price, material, rating and sale', () {
      final lamps = filterProducts(
        products,
        const ProductFilter(category: ProductCategory.lamp),
      );
      expect(lamps, isNotEmpty);
      expect(lamps.every((p) => p.category == ProductCategory.lamp), isTrue);

      final cheapOak = filterProducts(
        products,
        const ProductFilter(maxPrice: 500, materials: {'Oak'}),
      );
      expect(cheapOak, isNotEmpty);
      expect(
        cheapOak.every((p) => p.material == 'Oak' && p.price <= 500),
        isTrue,
      );

      final sale = filterProducts(
        products,
        const ProductFilter(onlyDiscounted: true, minRating: 4.7),
      );
      expect(
        sale.every((p) => p.discountPercent > 0 && p.rating >= 4.7),
        isTrue,
      );
    });

    test('search matches name, material and category', () {
      final velvet = filterProducts(
        products,
        const ProductFilter(query: ' VELVET '),
      );
      expect(velvet, isNotEmpty);
      expect(velvet.every((p) => p.material == 'Velvet'), isTrue);
      expect(
        filterProducts(
          products,
          const ProductFilter(query: 'lamps'),
          categoryNames: const {
            ProductCategory.lamp: ['Lamps'],
          },
        ),
        isNotEmpty,
      );
      expect(
        filterProducts(products, const ProductFilter(query: 'zzz')),
        isEmpty,
      );
    });

    test('sorts by price, rating and popularity', () {
      final asc = filterProducts(
        products,
        const ProductFilter(sort: SortOption.priceAsc),
      );
      for (var i = 1; i < asc.length; i++) {
        expect(asc[i].price, greaterThanOrEqualTo(asc[i - 1].price));
      }
      final desc = filterProducts(
        products,
        const ProductFilter(sort: SortOption.priceDesc),
      );
      expect(
        desc.first.price,
        desc.map((p) => p.price).reduce((a, b) => a > b ? a : b),
      );
      final popular = filterProducts(products, const ProductFilter());
      expect(popular.first.popularity, 98);
    });

    test('filter counts only the sheet filters', () {
      const f = ProductFilter(query: 'x', category: ProductCategory.bed);
      expect(f.activeCount, 0);
      expect(f.isBrowsing, isFalse);
      expect(const ProductFilter().isBrowsing, isTrue);
      expect(
        const ProductFilter(
          minPrice: 10,
          onlyDiscounted: true,
          minRating: 4,
        ).activeCount,
        3,
      );
      expect(
        const ProductFilter(
          minPrice: 10,
          category: ProductCategory.bed,
        ).resetSheet().category,
        ProductCategory.bed,
      );
    });
  });

  test(
    'GetRelatedProducts returns same-category products, not the product',
    () {
      final sofa = SeedCatalog.byId('p1');
      final related = const GetRelatedProducts()(products, sofa, limit: 3);
      expect(related, hasLength(3));
      expect(
        related.every((p) => p.category == sofa.category && p != sofa),
        isTrue,
      );
    },
  );

  test('CatalogSummary finds materials and the top price', () {
    final summary = CatalogSummary(products);
    expect(summary.materials, contains('Oak'));
    expect(summary.materials, orderedEquals([...summary.materials]..sort()));
    expect(summary.maxPrice, 1450);
  });

  group('CatalogCubit', () {
    late FakeCatalogRepository repository;
    late CatalogCubit cubit;

    setUp(() {
      repository = FakeCatalogRepository(
        products,
        banners: SeedCatalog.banners(),
      );
      cubit = CatalogCubit(
        getProducts: GetProducts(repository),
        getBanners: GetBanners(repository),
        filterProducts: filterProducts,
        getRelatedProducts: const GetRelatedProducts(),
      );
    });
    tearDown(() => cubit.close());

    test('loads products and banners', () async {
      expect(cubit.state.status, LoadStatus.initial);
      await cubit.load();
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.all, hasLength(23));
      expect(cubit.state.visible, hasLength(23));
      expect(cubit.state.banners, hasLength(3));
      expect(cubit.state.summary!.maxPrice, 1450);
      expect(cubit.state.productById('p8')!.name, 'Shell Chair');
      expect(cubit.state.productById('nope'), isNull);
    });

    test('filters instantly after loading', () async {
      await cubit.load();
      cubit.selectCategory(ProductCategory.bed);
      expect(
        cubit.state.visible.every((p) => p.category == ProductCategory.bed),
        isTrue,
      );
      cubit.sortBy(SortOption.priceDesc);
      expect(
        cubit.state.visible.first.price,
        greaterThanOrEqualTo(cubit.state.visible.last.price),
      );
      cubit.search('linen');
      expect(cubit.state.visible.map((p) => p.id), ['p17']);
    });

    test('a failed load keeps the failure and lets the user retry', () async {
      repository.failure = const NetworkFailure();
      await cubit.load();
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());

      repository.failure = null;
      await cubit.load(forceRefresh: true);
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.failure, isNull);
    });

    test('a banner error does not fail the page', () async {
      repository.banners = const [];
      await cubit.load();
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.banners, isEmpty);
    });
  });
}
