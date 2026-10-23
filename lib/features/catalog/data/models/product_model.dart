import 'package:furniture_store/core/utils/json_reader.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_color.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_dimensions.dart';
import 'package:furniture_store/features/catalog/domain/entities/review.dart';

/// Converts a Firestore `products/{id}` document to a [Product].
abstract final class ProductModel {
  static Product fromMap(String id, Map<String, dynamic> map) {
    final json = JsonReader(map);
    final categoryName = json.string('category');
    final category = ProductCategory.values
        .where((c) => c.name == categoryName)
        .firstOrNull;
    if (category == null) {
      throw FormatException('Unknown category "$categoryName"');
    }
    final colors = json.objects('colors').map(_color).toList();
    if (colors.isEmpty) throw const FormatException('A product needs a colour');
    final images = json.list<String>('images');
    if (images.isEmpty) throw const FormatException('A product needs a photo');

    return Product(
      id: id,
      name: json.string('name'),
      category: category,
      price: json.integer('price'),
      oldPrice: json.optionalInt('oldPrice'),
      rating: json.number('rating'),
      reviewCount: json.integer('reviewCount'),
      popularity: json.integer('popularity'),
      isNew: json.booleanOr('isNew', orElse: false),
      material: json.string('material'),
      description: json.string('description'),
      dimensions: ProductDimensions(
        widthCm: json.integer('widthCm'),
        depthCm: json.integer('depthCm'),
        heightCm: json.integer('heightCm'),
      ),
      floorStanding: json.booleanOr('floorStanding', orElse: true),
      styles: {
        for (final name in json.list<String>('styles'))
          ?DesignStyle.tryParse(name),
      },
      images: images,
      colors: colors,
      reviews: json.objects('reviews').map(_review).toList(),
    );
  }

  static ProductColor _color(JsonReader json) =>
      ProductColor(json.string('name'), json.integer('argb'));

  static Review _review(JsonReader json) => Review(
    author: json.string('author'),
    rating: json.integer('rating'),
    comment: json.string('comment'),
    date: DateTime.parse(json.string('date')),
  );
}
