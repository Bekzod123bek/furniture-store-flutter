import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';

abstract interface class CartRepository {
  Future<Result<CartSnapshot>> getCart();
  Future<Result<void>> saveCart(CartSnapshot snapshot);
}
