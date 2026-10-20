import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_cubit.dart';
import 'features/auth/auth_cubit.dart';
import 'features/shop/data/mock_product_repository.dart';
import 'features/shop/data/prefs_shop_storage.dart';
import 'features/shop/domain/product_repository.dart';
import 'features/shop/domain/shop_storage.dart';
import 'features/shop/presentation/cubit/cart_cubit.dart';
import 'features/shop/presentation/cubit/catalog_cubit.dart';
import 'features/shop/presentation/cubit/favorites_cubit.dart';
import 'features/shop/presentation/cubit/orders_cubit.dart';

final sl = GetIt.instance;

/// [fast] removes the artificial loading delays (used in tests).
Future<void> setupDependencies({bool fast = false}) async {
  await sl.reset();
  final prefs = await SharedPreferences.getInstance();
  final delay = fast ? Duration.zero : const Duration(milliseconds: 600);
  sl
    ..registerSingleton(prefs)
    ..registerLazySingleton<ProductRepository>(
      () => MockProductRepository(delay: delay),
    )
    ..registerLazySingleton<ShopStorage>(() => PrefsShopStorage(sl()))
    ..registerFactory(() => ThemeCubit(sl()))
    ..registerFactory(() => AuthCubit(sl(), delay: delay))
    ..registerFactory(() => CatalogCubit(sl())..load())
    ..registerFactory(() => FavoritesCubit(sl(), sl()))
    ..registerFactory(() => CartCubit(sl(), sl()))
    ..registerFactory(() => OrdersCubit(sl()));
}
