import '../domain/entities.dart';
import '../domain/product_repository.dart';

String _photo(String id) => 'https://images.unsplash.com/photo-$id?w=900&q=80';

/// Banner photos for the home carousel (Unsplash).
final bannerImages = [
  _photo('1631679706909-1844bbd07221'),
  _photo('1538688525198-9b88f6f53126'),
  _photo('1617806118233-18e1de247200'),
];

/// Onboarding photos (Unsplash).
final onboardingImages = [
  _photo('1616486338812-3dadae4b4ace'),
  _photo('1618220179428-22790b461013'),
  _photo('1556228453-efd6c1ff04f6'),
];

const _reviewPool = [
  Review(
    author: 'Dilnoza R.',
    rating: 5,
    comment: 'Looks even better than in the photos. Delivery was on time.',
    date: '12 Sep 2026',
  ),
  Review(
    author: 'Jasur T.',
    rating: 4,
    comment: 'Good quality for the price. Assembly took about 30 minutes.',
    date: '28 Aug 2026',
  ),
  Review(
    author: 'Madina K.',
    rating: 5,
    comment: 'Very comfortable and the colour matches our living room.',
    date: '3 Aug 2026',
  ),
  Review(
    author: 'Aziz N.',
    rating: 4,
    comment: 'Solid build. Would like a few more colour options.',
    date: '19 Jul 2026',
  ),
  Review(
    author: 'Kamola S.',
    rating: 3,
    comment: 'Nice design, but the box arrived slightly damaged.',
    date: '2 Jul 2026',
  ),
];

List<Review> _reviews(int seed) => [
  for (var i = 0; i < 3; i++) _reviewPool[(seed + i) % _reviewPool.length],
];

const _neutral = [
  ProductColor('Sand', 0xFFD8C3A5),
  ProductColor('Graphite', 0xFF3D3D3D),
  ProductColor('Ivory', 0xFFF2EDE4),
];
const _wood = [
  ProductColor('Natural oak', 0xFFC8A27A),
  ProductColor('Walnut', 0xFF5D4037),
  ProductColor('White', 0xFFF5F5F5),
];
const _metal = [
  ProductColor('Black', 0xFF1F1F1F),
  ProductColor('Brass', 0xFFB8925A),
  ProductColor('White', 0xFFF5F5F5),
];

/// In-memory catalog with sample data. No backend is used.
class MockProductRepository implements ProductRepository {
  MockProductRepository({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;

  static final products = <Product>[
    Product(
      id: 'p1',
      name: 'Emerald Velvet Sofa',
      category: Category.sofa,
      price: 899,
      oldPrice: 1099,
      rating: 4.8,
      reviewCount: 214,
      popularity: 98,
      material: 'Velvet',
      dimensions: '214 × 92 × 84 cm',
      description:
          'A three-seat sofa in soft velvet with tapered walnut legs. Deep seat '
          'cushions with high-resilience foam keep their shape for years.',
      images: [
        _photo('1555041469-a586c61ea9bc'),
        _photo('1616486338812-3dadae4b4ace'),
        _photo('1631679706909-1844bbd07221'),
      ],
      colors: const [
        ProductColor('Emerald', 0xFF1F5E4E),
        ProductColor('Navy', 0xFF22304A),
        ProductColor('Rose', 0xFFC98E8E),
      ],
      reviews: _reviews(0),
    ),
    Product(
      id: 'p2',
      name: 'Cognac Leather Sofa',
      category: Category.sofa,
      price: 1450,
      rating: 4.9,
      reviewCount: 168,
      popularity: 95,
      material: 'Leather',
      dimensions: '228 × 95 × 82 cm',
      description:
          'Mid-century sofa in full-grain leather that develops a rich patina '
          'over time. Solid wood frame and pocket-spring seat.',
      images: [
        _photo('1540574163026-643ea20ade25'),
        _photo('1600210492486-724fe5c67fb0'),
        _photo('1560448204-e02f11c3d0e2'),
      ],
      colors: const [
        ProductColor('Cognac', 0xFFA0602F),
        ProductColor('Black', 0xFF1F1F1F),
      ],
      reviews: _reviews(1),
    ),
    Product(
      id: 'p3',
      name: 'Chester Tufted Sofa',
      category: Category.sofa,
      price: 760,
      rating: 4.5,
      reviewCount: 96,
      popularity: 80,
      material: 'Fabric',
      dimensions: '200 × 88 × 80 cm',
      description:
          'Classic button-tufted backrest with a modern, slim silhouette. '
          'Removable covers that can be washed at 30°C.',
      images: [
        _photo('1493663284031-b7e3aefcae8e'),
        _photo('1600121848594-d8644e57abab'),
      ],
      colors: _neutral,
      reviews: _reviews(2),
    ),
    Product(
      id: 'p4',
      name: 'Sky Blue Sofa',
      category: Category.sofa,
      price: 690,
      oldPrice: 820,
      rating: 4.6,
      reviewCount: 74,
      popularity: 76,
      isNew: true,
      material: 'Fabric',
      dimensions: '190 × 86 × 82 cm',
      description:
          'Compact two-and-a-half seat sofa that fits small apartments. '
          'Soft woven fabric in a calm blue tone.',
      images: [
        _photo('1484101403633-562f891dc89a'),
        _photo('1556228453-efd6c1ff04f6'),
      ],
      colors: const [
        ProductColor('Sky', 0xFF9DB4CF),
        ProductColor('Sand', 0xFFD8C3A5),
      ],
      reviews: _reviews(3),
    ),
    Product(
      id: 'p5',
      name: 'Coral Loveseat',
      category: Category.sofa,
      price: 540,
      rating: 4.4,
      reviewCount: 41,
      popularity: 70,
      isNew: true,
      material: 'Velvet',
      dimensions: '150 × 84 × 80 cm',
      description:
          'A playful two-seater in coral velvet. Light enough to move around '
          'and comfortable enough for a long movie night.',
      images: [
        _photo('1567016432779-094069958ea5'),
        _photo('1618220179428-22790b461013'),
      ],
      colors: const [
        ProductColor('Coral', 0xFFD0562E),
        ProductColor('Mustard', 0xFFD9A62E),
      ],
      reviews: _reviews(4),
    ),
    Product(
      id: 'p6',
      name: 'Sunny Wingback Armchair',
      category: Category.armchair,
      price: 380,
      oldPrice: 450,
      rating: 4.7,
      reviewCount: 132,
      popularity: 90,
      material: 'Fabric',
      dimensions: '78 × 80 × 98 cm',
      description:
          'Wingback armchair with a high back for reading corners. '
          'Bright yellow fabric and oiled beech legs.',
      images: [
        _photo('1550226891-ef816aed4a98'),
        _photo('1586023492125-27b2c045efd7'),
      ],
      colors: const [
        ProductColor('Sunflower', 0xFFE3B23C),
        ProductColor('Olive', 0xFF6B7A3A),
      ],
      reviews: _reviews(0),
    ),
    Product(
      id: 'p7',
      name: 'Cloud Tufted Chair',
      category: Category.armchair,
      price: 310,
      rating: 4.3,
      reviewCount: 58,
      popularity: 60,
      material: 'Fabric',
      dimensions: '66 × 64 × 82 cm',
      description:
          'Small tufted armchair with turned white legs. A soft accent for a '
          'bedroom or a dressing area.',
      images: [
        _photo('1567538096630-e0c55bd6374c'),
        _photo('1519947486511-46149fa0a254'),
      ],
      colors: _neutral,
      reviews: _reviews(1),
    ),
    Product(
      id: 'p8',
      name: 'Shell Chair',
      category: Category.chair,
      price: 120,
      rating: 4.6,
      reviewCount: 305,
      popularity: 92,
      material: 'Plastic',
      dimensions: '47 × 53 × 82 cm',
      description:
          'Moulded shell seat with a padded cushion and beech legs. '
          'Stackable and easy to clean.',
      images: [
        _photo('1592078615290-033ee584e267'),
        _photo('1581539250439-c96689b516dd'),
      ],
      colors: _metal,
      reviews: _reviews(2),
    ),
    Product(
      id: 'p9',
      name: 'Nordic Dining Chair',
      category: Category.chair,
      price: 165,
      oldPrice: 199,
      rating: 4.5,
      reviewCount: 87,
      popularity: 72,
      material: 'Oak',
      dimensions: '50 × 55 × 88 cm',
      description:
          'Upholstered seat on a solid oak frame. Pairs well with the Oak '
          'Dining Table.',
      images: [
        _photo('1598300042247-d088f8ab3a91'),
        _photo('1617806118233-18e1de247200'),
      ],
      colors: _neutral,
      reviews: _reviews(3),
    ),
    Product(
      id: 'p10',
      name: 'Birch Bar Stool',
      category: Category.chair,
      price: 75,
      rating: 4.2,
      reviewCount: 39,
      popularity: 50,
      material: 'Wood',
      dimensions: '40 × 40 × 75 cm',
      description: 'Light birch stool for a kitchen island or a breakfast bar.',
      images: [_photo('1503602642458-232111445657')],
      colors: _wood,
      reviews: _reviews(4),
    ),
    Product(
      id: 'p11',
      name: 'Rustic Wooden Chair',
      category: Category.chair,
      price: 95,
      rating: 4.1,
      reviewCount: 22,
      popularity: 40,
      material: 'Wood',
      dimensions: '44 × 48 × 90 cm',
      description: 'Hand-finished wooden chair with a woven cane seat.',
      images: [_photo('1506439773649-6e0eb8cfb237')],
      colors: _wood,
      reviews: _reviews(0),
    ),
    Product(
      id: 'p12',
      name: 'Round Café Table',
      category: Category.table,
      price: 280,
      oldPrice: 340,
      rating: 4.6,
      reviewCount: 64,
      popularity: 74,
      material: 'Wood',
      dimensions: 'Ø 90 × 74 cm',
      description:
          'Round table with a white top and beech legs. Seats four people.',
      images: [
        _photo('1533090481720-856c6e3c1fdc'),
        _photo('1554295405-abb8fd54f153'),
      ],
      colors: _wood,
      reviews: _reviews(1),
    ),
    Product(
      id: 'p13',
      name: 'Oak Dining Table',
      category: Category.table,
      price: 640,
      rating: 4.8,
      reviewCount: 118,
      popularity: 88,
      material: 'Oak',
      dimensions: '180 × 90 × 75 cm',
      description: 'Solid oak dining table for six with a natural oil finish.',
      images: [
        _photo('1577140917170-285929fb55b7'),
        _photo('1617806118233-18e1de247200'),
      ],
      colors: _wood,
      reviews: _reviews(2),
    ),
    Product(
      id: 'p14',
      name: 'Studio Work Desk',
      category: Category.table,
      price: 420,
      rating: 4.7,
      reviewCount: 53,
      popularity: 78,
      isNew: true,
      material: 'Oak',
      dimensions: '140 × 65 × 75 cm',
      description:
          'Minimal desk with a hidden cable tray and a leather pen holder.',
      images: [_photo('1611269154421-4e27233ac5c7')],
      colors: _wood,
      reviews: _reviews(3),
    ),
    Product(
      id: 'p15',
      name: 'Live Edge Side Table',
      category: Category.table,
      price: 130,
      rating: 4.4,
      reviewCount: 31,
      popularity: 55,
      material: 'Wood',
      dimensions: '50 × 35 × 55 cm',
      description: 'Side table carved from a single piece of reclaimed wood.',
      images: [_photo('1532372320572-cda25653a26d')],
      colors: _wood,
      reviews: _reviews(4),
    ),
    Product(
      id: 'p16',
      name: 'Royal Tufted Bed',
      category: Category.bed,
      price: 1280,
      oldPrice: 1490,
      rating: 4.8,
      reviewCount: 142,
      popularity: 89,
      material: 'Velvet',
      dimensions: '180 × 200 cm',
      description:
          'King size bed with a tall tufted headboard and a sturdy slatted '
          'base. Mattress not included.',
      images: [
        _photo('1505693416388-ac5ce068fe85'),
        _photo('1595526114035-0d45ed16cfbf'),
      ],
      colors: _neutral,
      reviews: _reviews(0),
    ),
    Product(
      id: 'p17',
      name: 'Linen Platform Bed',
      category: Category.bed,
      price: 980,
      rating: 4.6,
      reviewCount: 77,
      popularity: 71,
      material: 'Linen',
      dimensions: '160 × 200 cm',
      description:
          'Low platform bed upholstered in washed linen with a padded headboard.',
      images: [
        _photo('1522771739844-6a9f6d5f14af'),
        _photo('1616627561950-9f746e330187'),
        _photo('1595526114035-0d45ed16cfbf'),
      ],
      colors: _neutral,
      reviews: _reviews(1),
    ),
    Product(
      id: 'p18',
      name: 'Industrial Floor Lamp',
      category: Category.lamp,
      price: 145,
      rating: 4.5,
      reviewCount: 98,
      popularity: 69,
      material: 'Metal',
      dimensions: 'H 176 cm',
      description: 'Adjustable floor lamp with a large matte shade. E27 bulb.',
      images: [
        _photo('1507473885765-e6ed057f782c'),
        _photo('1524758631624-e2822e304c36'),
      ],
      colors: _metal,
      reviews: _reviews(2),
    ),
    Product(
      id: 'p19',
      name: 'Dome Pendant Lamp',
      category: Category.lamp,
      price: 89,
      oldPrice: 110,
      rating: 4.4,
      reviewCount: 45,
      popularity: 58,
      material: 'Metal',
      dimensions: 'Ø 35 cm',
      description: 'Simple dome pendant for dining tables and kitchen islands.',
      images: [_photo('1513506003901-1e6a229e2d15')],
      colors: _metal,
      reviews: _reviews(3),
    ),
    Product(
      id: 'p20',
      name: 'Orb Desk Lamp',
      category: Category.lamp,
      price: 65,
      rating: 4.3,
      reviewCount: 27,
      popularity: 45,
      isNew: true,
      material: 'Metal',
      dimensions: 'H 42 cm',
      description: 'Warm dimmable desk lamp with a soft opal glass orb.',
      images: [_photo('1543198126-a8ad8e47fb22')],
      colors: _metal,
      reviews: _reviews(4),
    ),
    Product(
      id: 'p21',
      name: 'Floating Wall Shelves',
      category: Category.storage,
      price: 210,
      rating: 4.5,
      reviewCount: 61,
      popularity: 63,
      material: 'Wood',
      dimensions: 'Set of 3',
      description: 'Wall-mounted shelf set with hidden brackets.',
      images: [_photo('1594026112284-02bb6f3352fe')],
      colors: _wood,
      reviews: _reviews(0),
    ),
    Product(
      id: 'p22',
      name: 'Oak Shelving Unit',
      category: Category.storage,
      price: 340,
      rating: 4.6,
      reviewCount: 49,
      popularity: 61,
      material: 'Oak',
      dimensions: '60 × 35 × 190 cm',
      description: 'Tall open shelving for books, plants and baskets.',
      images: [_photo('1595428774223-ef52624120d2')],
      colors: _wood,
      reviews: _reviews(1),
    ),
    Product(
      id: 'p23',
      name: 'Walnut Wardrobe',
      category: Category.storage,
      price: 890,
      oldPrice: 990,
      rating: 4.7,
      reviewCount: 36,
      popularity: 66,
      material: 'Wood',
      dimensions: '120 × 60 × 210 cm',
      description: 'Two-door wardrobe with a hanging rail and two shelves.',
      images: [_photo('1558997519-83ea9252edf8')],
      colors: _wood,
      reviews: _reviews(2),
    ),
  ];

  @override
  Future<List<Product>> getProducts({
    ProductFilter filter = const ProductFilter(),
  }) async {
    await Future<void>.delayed(delay);
    final q = filter.query.trim().toLowerCase();
    final result = products.where((p) {
      if (filter.category != null && p.category != filter.category)
        return false;
      if (q.isNotEmpty &&
          !p.name.toLowerCase().contains(q) &&
          !p.material.toLowerCase().contains(q) &&
          !p.category.label.toLowerCase().contains(q)) {
        return false;
      }
      if (p.price < filter.minPrice) return false;
      if (filter.maxPrice != null && p.price > filter.maxPrice!) return false;
      if (filter.materials.isNotEmpty &&
          !filter.materials.contains(p.material)) {
        return false;
      }
      if (p.rating < filter.minRating) return false;
      if (filter.onlyDiscounted && p.discountPercent == 0) return false;
      return true;
    }).toList();

    result.sort(switch (filter.sort) {
      SortOption.popular => (a, b) => b.popularity.compareTo(a.popularity),
      SortOption.newest => (a, b) => (b.isNew ? 1 : 0).compareTo(
        a.isNew ? 1 : 0,
      ),
      SortOption.priceAsc => (a, b) => a.price.compareTo(b.price),
      SortOption.priceDesc => (a, b) => b.price.compareTo(a.price),
      SortOption.rating => (a, b) => b.rating.compareTo(a.rating),
    });
    return result;
  }

  @override
  Product? findById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  List<Product> related(Product product, {int limit = 6}) => products
      .where((p) => p.category == product.category && p != product)
      .take(limit)
      .toList();

  @override
  List<String> get materials =>
      (products.map((p) => p.material).toSet().toList()..sort());

  @override
  int get maxPrice =>
      products.map((p) => p.price).reduce((a, b) => a > b ? a : b);
}
