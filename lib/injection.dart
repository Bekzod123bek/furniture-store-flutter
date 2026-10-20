import 'package:get_it/get_it.dart';

import 'features/shop/data/mock_product_repository.dart';
import 'features/shop/domain/product_repository.dart';
import 'features/shop/presentation/cubit/cart_cubit.dart';
import 'features/shop/presentation/cubit/catalog_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await sl.reset();
  sl
    ..registerLazySingleton<ProductRepository>(MockProductRepository.new)
    ..registerFactory(() => CatalogCubit(sl())..load())
    ..registerLazySingleton(CartCubit.new);
}
