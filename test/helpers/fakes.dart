import 'dart:async';
import 'dart:typed_data';

import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/features/auth/domain/entities/app_user.dart';
import 'package:furniture_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';
import 'package:furniture_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:furniture_store/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:furniture_store/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/domain/repositories/orders_repository.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_analysis_repository.dart';
import 'package:furniture_store/features/room_design/domain/repositories/room_photo_picker.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/repositories/settings_repository.dart';

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository(this.products, {this.banners = const []});

  List<Product> products;
  List<PromoBanner> banners;
  Failure? failure;
  int productLoads = 0;

  @override
  Future<Result<List<Product>>> getProducts({bool forceRefresh = false}) async {
    productLoads++;
    final f = failure;
    return f != null ? Err(f) : Ok(products);
  }

  @override
  Future<Result<List<PromoBanner>>> getBanners() async =>
      failure != null ? Err(failure!) : Ok(banners);
}

class FakeCartRepository implements CartRepository {
  CartSnapshot saved = const CartSnapshot();
  Failure? failure;
  int saves = 0;

  @override
  Future<Result<CartSnapshot>> getCart() async =>
      failure != null ? Err(failure!) : Ok(saved);

  @override
  Future<Result<void>> saveCart(CartSnapshot snapshot) async {
    saves++;
    if (failure != null) return Err(failure!);
    saved = snapshot;
    return const Ok(null);
  }
}

class FakeFavoritesRepository implements FavoritesRepository {
  List<String> ids = [];
  Failure? failure;

  @override
  Future<Result<List<String>>> getFavoriteIds() async =>
      failure != null ? Err(failure!) : Ok(ids);

  @override
  Future<Result<void>> saveFavoriteIds(List<String> ids) async {
    if (failure != null) return Err(failure!);
    this.ids = ids;
    return const Ok(null);
  }
}

class FakeOrdersRepository implements OrdersRepository {
  final List<Order> orders = [];
  ShippingAddress? address;
  Failure? placeFailure;
  Failure? loadFailure;

  @override
  Future<Result<List<Order>>> getOrders() async =>
      loadFailure != null ? Err(loadFailure!) : Ok(orders.reversed.toList());

  @override
  Future<Result<void>> placeOrder(Order order) async {
    if (placeFailure != null) return Err(placeFailure!);
    orders.removeWhere((o) => o.id == order.id);
    orders.add(order);
    return const Ok(null);
  }

  @override
  Future<Result<void>> cancelOrder(String orderId) async {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return const Err(NotFoundFailure());
    orders[index] = orders[index].copyWith(status: OrderStatus.cancelled);
    return const Ok(null);
  }

  @override
  Future<Result<ShippingAddress?>> getSavedAddress() async => Ok(address);

  @override
  Future<Result<void>> saveAddress(ShippingAddress address) async {
    this.address = address;
    return const Ok(null);
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? initial}) : _user = initial {
    _controller = StreamController<AppUser?>.broadcast(
      onListen: () => _controller.add(_user),
    );
  }

  late final StreamController<AppUser?> _controller;
  AppUser? _user;
  Failure? failure;

  void _emit(AppUser? user) {
    _user = user;
    _controller.add(user);
  }

  @override
  Stream<AppUser?> watchUser() => _controller.stream;

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    if (failure != null) return Err(failure!);
    final user = AppUser(uid: 'u1', name: 'Test User', email: email);
    _emit(user);
    return Ok(user);
  }

  @override
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (failure != null) return Err(failure!);
    final user = AppUser(uid: 'u1', name: name, email: email);
    _emit(user);
    return Ok(user);
  }

  @override
  Future<Result<void>> signOut() async {
    _emit(null);
    return const Ok(null);
  }

  @override
  Future<Result<void>> sendPasswordReset(String email) async =>
      failure != null ? Err(failure!) : const Ok(null);
}

class FakeSettingsRepository implements SettingsRepository {
  AppSettings settings = const AppSettings();
  int saves = 0;

  @override
  Future<Result<AppSettings>> getSettings() async => Ok(settings);

  @override
  Future<Result<void>> saveSettings(AppSettings value) async {
    saves++;
    settings = value;
    return const Ok(null);
  }
}

class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.completed = false});

  bool completed;

  @override
  Future<Result<bool>> isCompleted() async => Ok(completed);

  @override
  Future<Result<void>> markCompleted() async {
    completed = true;
    return const Ok(null);
  }
}

class FakeRoomAnalysisRepository implements RoomAnalysisRepository {
  FakeRoomAnalysisRepository(this.analysis);

  RoomAnalysis analysis;
  Failure? failure;
  int calls = 0;
  String? lastLanguage;

  @override
  Future<Result<RoomAnalysis>> analyze(
    RoomPhoto photo, {
    required String languageCode,
  }) async {
    calls++;
    lastLanguage = languageCode;
    return failure != null ? Err(failure!) : Ok(analysis);
  }
}

class FakeRoomPhotoPicker implements RoomPhotoPicker {
  /// `null` means the user cancels.
  RoomPhoto? photo = RoomPhoto(
    bytes: Uint8List.fromList(_tinyPng),
    mimeType: 'image/png',
  );
  Failure? failure;

  @override
  Future<Result<RoomPhoto?>> pick(PhotoSource source) async =>
      failure != null ? Err(failure!) : Ok(photo);
}

/// A valid 1×1 PNG so `Image.memory` can decode it in widget tests.
const _tinyPng = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0xF8,
  0xFF,
  0xFF,
  0x3F,
  0x00,
  0x05,
  0xFE,
  0x02,
  0xFE,
  0xA7,
  0x35,
  0x81,
  0x84,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];
