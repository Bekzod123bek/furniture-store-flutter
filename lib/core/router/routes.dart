import 'package:furniture_store/core/router/route_args.dart';

/// Named routes. Features navigate by name, so they do not import each
/// other's pages. The pages are built in `app/router/app_router.dart`.
abstract final class Routes {
  /// Argument: [ProductDetailsArgs].
  static const productDetails = '/product';
  static const checkout = '/checkout';

  /// Argument: [OrderSuccessArgs].
  static const orderSuccess = '/order-success';
  static const orders = '/orders';
  static const roomScan = '/room-scan';

  /// Argument: [LocationPickerArgs]. Returns the chosen `PlaceAddress`.
  static const locationPicker = '/location';
}
