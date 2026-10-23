import 'package:flutter/material.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';

extension CategoryIcon on ProductCategory {
  IconData get icon => switch (this) {
    ProductCategory.sofa => Icons.weekend_outlined,
    ProductCategory.armchair => Icons.chair_outlined,
    ProductCategory.chair => Icons.event_seat_outlined,
    ProductCategory.table => Icons.table_restaurant_outlined,
    ProductCategory.bed => Icons.bed_outlined,
    ProductCategory.lamp => Icons.light_outlined,
    ProductCategory.storage => Icons.shelves,
  };
}
