import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furniture_store/core/firebase/firebase_current_user.dart';
import 'package:furniture_store/core/session/current_user_provider.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/core/utils/id_generator.dart';
import 'package:furniture_store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_store/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:furniture_store/features/auth/domain/usecases/register.dart';
import 'package:furniture_store/features/auth/domain/usecases/send_password_reset.dart';
import 'package:furniture_store/features/auth/domain/usecases/sign_in.dart';
import 'package:furniture_store/features/auth/domain/usecases/sign_out.dart';
import 'package:furniture_store/features/auth/domain/usecases/watch_auth_state.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/auth/presentation/cubit/login_cubit.dart';
import 'package:furniture_store/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:furniture_store/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:furniture_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:furniture_store/features/cart/domain/usecases/get_cart.dart';
import 'package:furniture_store/features/cart/domain/usecases/save_cart.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:furniture_store/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:furniture_store/features/catalog/domain/usecases/filter_products.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_banners.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_products.dart';
import 'package:furniture_store/features/catalog/domain/usecases/get_related_products.dart';
import 'package:furniture_store/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:furniture_store/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:furniture_store/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:furniture_store/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:furniture_store/features/favorites/domain/usecases/get_favorites.dart';
import 'package:furniture_store/features/favorites/domain/usecases/save_favorites.dart';
import 'package:furniture_store/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:furniture_store/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:furniture_store/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:furniture_store/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:furniture_store/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:furniture_store/features/onboarding/domain/usecases/is_onboarding_completed.dart';
import 'package:furniture_store/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:furniture_store/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:furniture_store/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';
import 'package:furniture_store/features/orders/domain/usecases/cancel_order.dart';
import 'package:furniture_store/features/orders/domain/usecases/get_orders.dart';
import 'package:furniture_store/features/orders/domain/usecases/get_saved_address.dart';
import 'package:furniture_store/features/orders/domain/usecases/place_order.dart';
import 'package:furniture_store/features/orders/presentation/cubit/checkout_cubit.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:furniture_store/features/room_design/data/datasources/image_picker_room_photo_picker.dart';
import 'package:furniture_store/features/room_design/data/datasources/room_analysis_remote_data_source.dart';
import 'package:furniture_store/features/room_design/data/repositories/room_analysis_repository_impl.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_analysis_repository.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_photo_picker.dart';
import 'package:furniture_store/features/room_design/domain/usecases/analyze_room.dart';
import 'package:furniture_store/features/room_design/domain/usecases/pick_room_photo.dart';
import 'package:furniture_store/features/room_design/domain/usecases/recommend_furniture.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_cubit.dart';
import 'package:furniture_store/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:furniture_store/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:furniture_store/features/settings/domain/repositories/settings_repository.dart';
import 'package:furniture_store/features/settings/domain/usecases/get_settings.dart';
import 'package:furniture_store/features/settings/domain/usecases/save_settings.dart';
import 'package:furniture_store/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/location/data/datasources/device_location_data_source.dart';
import 'package:furniture_store/features/location/data/datasources/geocoding_data_source.dart';
import 'package:furniture_store/features/location/data/repositories/location_repository_impl.dart';
import 'package:furniture_store/features/location/domain/repositories/location_repository.dart';
import 'package:furniture_store/features/location/domain/usecases/find_address.dart';
import 'package:furniture_store/features/location/domain/usecases/get_current_position.dart';
import 'package:furniture_store/features/location/presentation/cubit/location_picker_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app-wide service locator.
final sl = GetIt.instance;

/// Registers everything for the real app. Call after `Firebase.initializeApp`.
///
/// The registration is split by layer so tests can register fake
/// repositories and still reuse [registerDomainLayer] and
/// [registerPresentationLayer].
Future<void> setupDependencies() async {
  await sl.reset();
  await registerExternalServices();
  registerDataLayer();
  registerDomainLayer();
  registerPresentationLayer();
  await registerAppWideCubits();
}

/// SDK objects and platform services.
Future<void> registerExternalServices() async {
  sl
    ..registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    )
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseAI>(() => FirebaseAI.googleAI())
    ..registerLazySingleton<CurrentUserProvider>(
      () => FirebaseCurrentUser(sl()),
    )
    ..registerLazySingleton<IdGenerator>(RandomIdGenerator.new)
    ..registerLazySingleton<http.Client>(http.Client.new);
}

/// Data sources and repository implementations.
void registerDataLayer() {
  sl
    // Settings
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    )
    // Onboarding
    ..registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(sl()),
    )
    // Auth
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => FirebaseAuthDataSource(sl(), sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    // Catalog (the repository keeps an in-memory cache)
    ..registerLazySingleton<CatalogRemoteDataSource>(
      () => FirestoreCatalogDataSource(sl()),
    )
    ..registerLazySingleton<CatalogRepository>(
      () => CatalogRepositoryImpl(sl()),
    )
    // Cart
    ..registerLazySingleton<CartRemoteDataSource>(
      () => FirestoreCartDataSource(sl(), sl()),
    )
    ..registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()))
    // Favorites
    ..registerLazySingleton<FavoritesRemoteDataSource>(
      () => FirestoreFavoritesDataSource(sl(), sl()),
    )
    ..registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(sl()),
    )
    // Orders
    ..registerLazySingleton<OrdersRemoteDataSource>(
      () => FirestoreOrdersDataSource(sl(), sl()),
    )
    ..registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()))
    // Room design
    ..registerLazySingleton<RoomAnalysisRemoteDataSource>(
      () => GeminiRoomAnalysisDataSource(sl()),
    )
    ..registerLazySingleton<RoomAnalysisRepository>(
      () => RoomAnalysisRepositoryImpl(sl()),
    )
    ..registerLazySingleton<RoomPhotoPicker>(ImagePickerRoomPhotoPicker.new)
    // Location
    ..registerLazySingleton<DeviceLocationDataSource>(
      () => const GeolocatorDataSource(),
    )
    ..registerLazySingleton<GeocodingDataSource>(
      () => NominatimGeocodingDataSource(sl()),
    )
    ..registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(sl(), sl()),
    );
}

/// Use cases. They only depend on repository interfaces.
void registerDomainLayer() {
  sl
    ..registerLazySingleton(() => GetSettings(sl()))
    ..registerLazySingleton(() => SaveSettings(sl()))
    ..registerLazySingleton(() => GetCurrentPosition(sl()))
    ..registerLazySingleton(() => FindAddress(sl()))
    ..registerLazySingleton(() => IsOnboardingCompleted(sl()))
    ..registerLazySingleton(() => CompleteOnboarding(sl()))
    ..registerLazySingleton(() => WatchAuthState(sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => Register(sl()))
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(() => SendPasswordReset(sl()))
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetBanners(sl()))
    ..registerLazySingleton(FilterProducts.new)
    ..registerLazySingleton(GetRelatedProducts.new)
    ..registerLazySingleton(() => GetCart(sl(), sl()))
    ..registerLazySingleton(() => SaveCart(sl()))
    ..registerLazySingleton(() => GetFavorites(sl(), sl()))
    ..registerLazySingleton(() => SaveFavorites(sl()))
    ..registerLazySingleton(ToggleFavorite.new)
    ..registerLazySingleton(() => GetOrders(sl()))
    ..registerLazySingleton(() => CancelOrder(sl()))
    ..registerLazySingleton(() => GetSavedAddress(sl()))
    ..registerLazySingleton(() => PlaceOrder(sl(), sl()))
    ..registerLazySingleton(() => AnalyzeRoom(sl()))
    ..registerLazySingleton(() => PickRoomPhoto(sl()))
    ..registerLazySingleton(RecommendFurniture.new);
}

/// Cubits that belong to one screen or one signed-in session. A new instance
/// is created every time.
void registerPresentationLayer() {
  sl
    ..registerFactory(
      () => LoginCubit(signIn: sl(), register: sl(), sendPasswordReset: sl()),
    )
    ..registerFactory(
      () => CatalogCubit(
        getProducts: sl(),
        getBanners: sl(),
        filterProducts: sl(),
        getRelatedProducts: sl(),
      ),
    )
    ..registerFactory(
      () => FavoritesCubit(
        getFavorites: sl(),
        saveFavorites: sl(),
        toggleFavorite: sl(),
      ),
    )
    ..registerFactory(() => CartCubit(getCart: sl(), saveCart: sl()))
    ..registerFactory(() => OrdersCubit(getOrders: sl(), cancelOrder: sl()))
    ..registerFactory(
      () => CheckoutCubit(
        placeOrder: sl(),
        getSavedAddress: sl(),
        idGenerator: sl(),
      ),
    )
    ..registerFactory(
      () => LocationPickerCubit(getCurrentPosition: sl(), findAddress: sl()),
    )
    ..registerFactory(
      () => RoomScanCubit(
        pickRoomPhoto: sl(),
        analyzeRoom: sl(),
        getProducts: sl(),
        recommendFurniture: sl(),
      ),
    );
}

/// Cubits that live as long as the app. Their first value is read before the
/// first frame, so the right theme, language and screen appear immediately.
Future<void> registerAppWideCubits() async {
  final settings = (await sl<GetSettings>()(const NoParams())).valueOrNull;
  final onboarded = (await sl<IsOnboardingCompleted>()(
    const NoParams(),
  )).valueOrNull;

  sl
    ..registerSingleton<SettingsCubit>(
      SettingsCubit(
        initial: settings ?? const AppSettings(),
        saveSettings: sl(),
      ),
    )
    ..registerSingleton<OnboardingCubit>(
      OnboardingCubit(completed: onboarded ?? false, completeOnboarding: sl()),
    )
    ..registerSingleton<AuthCubit>(
      AuthCubit(watchAuthState: sl(), signOut: sl()),
    );
}
