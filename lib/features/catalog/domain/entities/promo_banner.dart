import 'package:equatable/equatable.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';

class PromoBanner extends Equatable {
  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.category,
  });

  final String id;
  final String title;
  final String subtitle;
  final String image;

  /// Category opened when the banner is tapped.
  final ProductCategory category;

  @override
  List<Object?> get props => [id, title, subtitle, image, category];
}
