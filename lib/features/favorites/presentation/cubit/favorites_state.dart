import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = LoadStatus.initial,
    this.products = const [],
    this.failure,
  });

  final LoadStatus status;

  /// Favorite products, newest first.
  final List<Product> products;
  final Failure? failure;

  bool contains(Product product) => products.contains(product);

  FavoritesState copyWith({
    LoadStatus? status,
    List<Product>? products,
    Failure? Function()? failure,
  }) => FavoritesState(
    status: status ?? this.status,
    products: products ?? this.products,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, products, failure];
}
