import 'package:furniture_store/core/error/guard.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._remote);

  final CartRemoteDataSource _remote;

  @override
  Future<Result<CartSnapshot>> getCart() => guard(_remote.fetchCart);

  @override
  Future<Result<void>> saveCart(CartSnapshot snapshot) =>
      guard(() => _remote.writeCart(snapshot));
}
