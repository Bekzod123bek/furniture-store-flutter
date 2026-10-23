import 'package:furniture_store/core/utils/json_reader.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';

/// Converts a Firestore `banners/{id}` document to a [PromoBanner].
abstract final class BannerModel {
  static PromoBanner fromMap(String id, Map<String, dynamic> map) {
    final json = JsonReader(map);
    final categoryName = json.string('category');
    final category = ProductCategory.values
        .where((c) => c.name == categoryName)
        .firstOrNull;
    if (category == null) {
      throw FormatException('Unknown category "$categoryName"');
    }
    return PromoBanner(
      id: id,
      title: json.string('title'),
      subtitle: json.string('subtitle'),
      image: json.string('image'),
      category: category,
    );
  }
}
