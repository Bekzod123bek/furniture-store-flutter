import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_store/core/firebase/firebase_call.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/features/catalog/data/models/banner_model.dart';
import 'package:furniture_store/features/catalog/data/models/product_model.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';

abstract interface class CatalogRemoteDataSource {
  Future<List<Product>> fetchProducts();
  Future<List<PromoBanner>> fetchBanners();
}

/// Reads the public catalog from Cloud Firestore.
class FirestoreCatalogDataSource implements CatalogRemoteDataSource {
  const FirestoreCatalogDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<Product>> fetchProducts() async {
    final snapshot = await firebaseCall(
      () => _firestore.collection('products').get(),
    );
    return _parseAll(snapshot.docs, ProductModel.fromMap, 'product');
  }

  @override
  Future<List<PromoBanner>> fetchBanners() async {
    final snapshot = await firebaseCall(
      () => _firestore.collection('banners').orderBy('order').get(),
    );
    return _parseAll(snapshot.docs, BannerModel.fromMap, 'banner');
  }

  /// A single malformed document must not hide the whole catalog, so bad
  /// documents are logged and skipped.
  List<T> _parseAll<T>(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    T Function(String id, Map<String, dynamic> data) parse,
    String kind,
  ) {
    final items = <T>[];
    for (final doc in docs) {
      try {
        items.add(parse(doc.id, doc.data()));
      } on FormatException catch (e, stack) {
        AppLogger.error('Skipped malformed $kind "${doc.id}"', e, stack);
      }
    }
    return items;
  }
}
