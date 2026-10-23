import 'package:furniture_store/features/location/domain/entities/geo_point.dart';

/// Arguments for [Routes.productDetails].
class ProductDetailsArgs {
  const ProductDetailsArgs({required this.productId, required this.heroTag});

  final String productId;

  /// Keeps Hero tags unique when one product appears in several lists.
  final String heroTag;
}

/// Arguments for [Routes.orderSuccess].
class OrderSuccessArgs {
  const OrderSuccessArgs({required this.orderNumber, required this.total});

  final String orderNumber;
  final int total;
}

/// Arguments for [Routes.locationPicker].
class LocationPickerArgs {
  const LocationPickerArgs({this.initial});

  /// Where the map opens; `null` starts from the device position.
  final GeoPoint? initial;
}
