import 'dart:convert';
import 'dart:io';

import 'package:furniture_store/features/catalog/data/models/banner_model.dart';
import 'package:furniture_store/features/catalog/data/models/product_model.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';

/// The real sample catalog (`tool/seed/catalog.json`), parsed with the app's
/// own models. Tests use it as realistic data, and it proves the file that is
/// uploaded to Firestore can be read by the app.
abstract final class SeedCatalog {
  static Map<String, dynamic> _json() =>
      jsonDecode(File('tool/seed/catalog.json').readAsStringSync())
          as Map<String, dynamic>;

  static List<Product> products() => [
    for (final raw
        in (_json()['products'] as List).cast<Map<String, dynamic>>())
      ProductModel.fromMap(raw['id'] as String, {...raw}..remove('id')),
  ];

  static List<PromoBanner> banners() => [
    for (final raw in (_json()['banners'] as List).cast<Map<String, dynamic>>())
      BannerModel.fromMap(raw['id'] as String, {...raw}..remove('id')),
  ];

  static Product byId(String id) => products().firstWhere((p) => p.id == id);
}
