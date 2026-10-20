import '../domain/entities.dart';
import '../domain/product_repository.dart';

/// In-memory catalog with sample data. No backend is used.
class MockProductRepository implements ProductRepository {
  static const _products = <Product>[
    Product(
      id: 'p1',
      name: 'Nordic 3-seat sofa',
      category: Category.sofa,
      price: 899,
      description: 'Soft fabric sofa with solid wood legs.',
      colorValue: 0xFF6D8B74,
    ),
    Product(
      id: 'p2',
      name: 'Corner sofa Milano',
      category: Category.sofa,
      price: 1450,
      description: 'Large corner sofa with storage under the seat.',
      colorValue: 0xFF5C6F7B,
    ),
    Product(
      id: 'p3',
      name: 'Oak dining table',
      category: Category.table,
      price: 640,
      description: 'Solid oak table for six people.',
      colorValue: 0xFFB08968,
    ),
    Product(
      id: 'p4',
      name: 'Coffee table Round',
      category: Category.table,
      price: 210,
      description: 'Round coffee table with a marble top.',
      colorValue: 0xFF9A8C98,
    ),
    Product(
      id: 'p5',
      name: 'Office chair Ergo',
      category: Category.chair,
      price: 320,
      description: 'Ergonomic chair with lumbar support.',
      colorValue: 0xFF3D405B,
    ),
    Product(
      id: 'p6',
      name: 'Dining chair set (4)',
      category: Category.chair,
      price: 280,
      description: 'Set of four upholstered dining chairs.',
      colorValue: 0xFFE07A5F,
    ),
    Product(
      id: 'p7',
      name: 'Queen bed Aura',
      category: Category.bed,
      price: 780,
      description: 'Queen size bed frame with a padded headboard.',
      colorValue: 0xFF81B29A,
    ),
  ];

  @override
  Future<List<Product>> getProducts({Category? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (category == null) return _products;
    return _products.where((p) => p.category == category).toList();
  }
}
