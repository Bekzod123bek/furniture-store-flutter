import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';
import 'package:furniture_store/features/catalog/domain/usecases/catalog_summary.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.status = LoadStatus.initial,
    this.all = const [],
    this.visible = const [],
    this.banners = const [],
    this.filter = const ProductFilter(),
    this.summary,
    this.failure,
  });

  final LoadStatus status;

  /// The whole catalog.
  final List<Product> all;

  /// Products matching [filter], already sorted.
  final List<Product> visible;
  final List<PromoBanner> banners;
  final ProductFilter filter;

  /// Materials and top price for the filter sheet; `null` until loaded.
  final CatalogSummary? summary;
  final Failure? failure;

  Product? productById(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }

  CatalogState copyWith({
    LoadStatus? status,
    List<Product>? all,
    List<Product>? visible,
    List<PromoBanner>? banners,
    ProductFilter? filter,
    CatalogSummary? summary,
    Failure? Function()? failure,
  }) => CatalogState(
    status: status ?? this.status,
    all: all ?? this.all,
    visible: visible ?? this.visible,
    banners: banners ?? this.banners,
    filter: filter ?? this.filter,
    summary: summary ?? this.summary,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, all, visible, banners, filter, failure];
}
