import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_dimensions.dart';
import 'package:furniture_store/features/catalog/domain/entities/review.dart';

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
    this.styles = const {},
    this.isNew = false,
    this.popularity = 0,
    this.floorStanding = true,
  });

  final String id;
  final String name;
  final ProductCategory category;

  /// Price in whole US dollars.
  final int price;
  final int? oldPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final String material;
  final ProductDimensions dimensions;
  final List<String> images;
  final List<ProductColor> colors;
  final List<Review> reviews;
  final Set<DesignStyle> styles;
  final bool isNew;
  final int popularity;

  /// Whether the product stands on the floor. Pendant lamps, wall shelves and
  /// desk lamps do not use floor space.
  final bool floorStanding;

  /// Discount in percent, or 0 when the product is not on sale.
  int get discountPercent => oldPrice == null || oldPrice! <= price
      ? 0
      : ((oldPrice! - price) * 100 / oldPrice!).round();

  /// Floor area used by the product, in square metres.
  double get floorAreaM2 => floorStanding ? dimensions.footprintM2 : 0;

  @override
  List<Object?> get props => [id];
}
