import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/app/di/injection.dart';
import 'package:furniture_store/core/router/route_args.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/features/catalog/presentation/pages/product_page.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:furniture_store/features/location/presentation/cubit/location_picker_cubit.dart';
import 'package:furniture_store/features/location/presentation/pages/location_picker_page.dart';
import 'package:furniture_store/features/orders/presentation/cubit/checkout_cubit.dart';
import 'package:furniture_store/features/orders/presentation/pages/checkout_page.dart';
import 'package:furniture_store/features/orders/presentation/pages/order_success_page.dart';
import 'package:furniture_store/features/orders/presentation/pages/orders_page.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_cubit.dart';
import 'package:furniture_store/features/room_design/presentation/pages/room_scan_page.dart';

/// Builds the page for every named route. This is the only place that knows
/// which feature owns which page.
abstract final class AppRouter {
  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.locationPicker) {
      final args = settings.arguments as LocationPickerArgs?;
      return MaterialPageRoute<PlaceAddress>(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => sl<LocationPickerCubit>(),
          child: LocationPickerPage(initial: args?.initial),
        ),
      );
    }
    final page = switch (settings.name) {
      Routes.productDetails => ProductPage(
        args: settings.arguments! as ProductDetailsArgs,
      ),
      Routes.checkout => BlocProvider(
        create: (_) => sl<CheckoutCubit>()..loadSavedAddress(),
        child: const CheckoutPage(),
      ),
      Routes.orderSuccess => OrderSuccessPage(
        args: settings.arguments! as OrderSuccessArgs,
      ),
      Routes.orders => const OrdersPage(),
      Routes.roomScan => BlocProvider(
        create: (_) => sl<RoomScanCubit>(),
        child: const RoomScanPage(),
      ),
      _ => null,
    };
    if (page == null) return null;
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
