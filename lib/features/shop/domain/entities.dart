import 'package:equatable/equatable.dart';

enum Category { sofa, armchair, chair, table, bed, lamp, storage }

extension CategoryLabel on Category {
  String get label => switch (this) {
    Category.sofa => 'Sofas',
    Category.armchair => 'Armchairs',
    Category.chair => 'Chairs',
    Category.table => 'Tables',
    Category.bed => 'Beds',
    Category.lamp => 'Lamps',
    Category.storage => 'Storage',
  };
}

enum SortOption { popular, newest, priceAsc, priceDesc, rating }

extension SortOptionLabel on SortOption {
  String get label => switch (this) {
    SortOption.popular => 'Popular',
    SortOption.newest => 'Newest',
    SortOption.priceAsc => 'Price: low to high',
    SortOption.priceDesc => 'Price: high to low',
    SortOption.rating => 'Top rated',
  };
}

class ProductColor extends Equatable {
  const ProductColor(this.name, this.value);

  final String name;
  final int value;

  @override
  List<Object?> get props => [name, value];
}

class Review extends Equatable {
  const Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String author;
  final int rating;
  final String comment;
  final String date;

  @override
  List<Object?> get props => [author, rating, comment, date];
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.material,
    required this.dimensions,
    required this.images,
    required this.colors,
    this.oldPrice,
    this.reviews = const [],
    this.isNew = false,
    this.popularity = 0,
  });

  final String id;
  final String name;
  final Category category;
  final int price;
  final int? oldPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final String material;
  final String dimensions;
  final List<String> images;
  final List<ProductColor> colors;
  final List<Review> reviews;
  final bool isNew;
  final int popularity;

  /// Discount in percent, or 0 when the product is not on sale.
  int get discountPercent => oldPrice == null || oldPrice! <= price
      ? 0
      : ((oldPrice! - price) * 100 / oldPrice!).round();

  @override
  List<Object?> get props => [id];
}

class ProductFilter extends Equatable {
  const ProductFilter({
    this.query = '',
    this.category,
    this.minPrice = 0,
    this.maxPrice,
    this.materials = const {},
    this.minRating = 0,
    this.onlyDiscounted = false,
    this.sort = SortOption.popular,
  });

  final String query;
  final Category? category;
  final int minPrice;

  /// `null` means no upper limit.
  final int? maxPrice;
  final Set<String> materials;
  final double minRating;
  final bool onlyDiscounted;
  final SortOption sort;

  /// Number of filters set in the filter sheet (search and category excluded).
  int get activeCount =>
      (minPrice > 0 || maxPrice != null ? 1 : 0) +
      (materials.isNotEmpty ? 1 : 0) +
      (minRating > 0 ? 1 : 0) +
      (onlyDiscounted ? 1 : 0);

  ProductFilter copyWith({
    String? query,
    Category? Function()? category,
    int? minPrice,
    int? Function()? maxPrice,
    Set<String>? materials,
    double? minRating,
    bool? onlyDiscounted,
    SortOption? sort,
  }) => ProductFilter(
    query: query ?? this.query,
    category: category != null ? category() : this.category,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
    materials: materials ?? this.materials,
    minRating: minRating ?? this.minRating,
    onlyDiscounted: onlyDiscounted ?? this.onlyDiscounted,
    sort: sort ?? this.sort,
  );

  /// Clears the filter sheet values but keeps search, category and sort.
  ProductFilter resetSheet() =>
      ProductFilter(query: query, category: category, sort: sort);

  @override
  List<Object?> get props => [
    query,
    category,
    minPrice,
    maxPrice,
    materials,
    minRating,
    onlyDiscounted,
    sort,
  ];
}

class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.color,
    required this.quantity,
  });

  final Product product;
  final ProductColor color;
  final int quantity;

  int get subtotal => product.price * quantity;

  bool sameLine(CartItem other) =>
      other.product == product && other.color == color;

  CartItem copyWith({int? quantity}) => CartItem(
    product: product,
    color: color,
    quantity: quantity ?? this.quantity,
  );

  Map<String, Object> toJson() => {
    'productId': product.id,
    'color': color.name,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [product, color, quantity];
}

/// Snapshot of a cart line stored inside an order.
class OrderLine extends Equatable {
  const OrderLine({
    required this.productId,
    required this.name,
    required this.image,
    required this.color,
    required this.quantity,
    required this.price,
  });

  final String productId;
  final String name;
  final String image;
  final String color;
  final int quantity;
  final int price;

  Map<String, Object> toJson() => {
    'productId': productId,
    'name': name,
    'image': image,
    'color': color,
    'quantity': quantity,
    'price': price,
  };

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
    productId: json['productId'] as String,
    name: json['name'] as String,
    image: json['image'] as String,
    color: json['color'] as String,
    quantity: json['quantity'] as int,
    price: json['price'] as int,
  );

  @override
  List<Object?> get props => [productId, name, color, quantity, price];
}

class Order extends Equatable {
  const Order({
    required this.id,
    required this.date,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.address,
    required this.paymentMethod,
  });

  final String id;
  final DateTime date;
  final List<OrderLine> lines;
  final int subtotal;
  final int discount;
  final int delivery;
  final String address;
  final String paymentMethod;

  int get total => subtotal - discount + delivery;
  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  Map<String, Object> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'lines': [for (final l in lines) l.toJson()],
    'subtotal': subtotal,
    'discount': discount,
    'delivery': delivery,
    'address': address,
    'paymentMethod': paymentMethod,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    lines: [
      for (final l in json['lines'] as List<dynamic>)
        OrderLine.fromJson(l as Map<String, dynamic>),
    ],
    subtotal: json['subtotal'] as int,
    discount: json['discount'] as int,
    delivery: json['delivery'] as int,
    address: json['address'] as String,
    paymentMethod: json['paymentMethod'] as String,
  );

  @override
  List<Object?> get props => [id];
}
