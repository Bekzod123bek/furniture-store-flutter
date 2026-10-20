import 'entities.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({Category? category});
}
