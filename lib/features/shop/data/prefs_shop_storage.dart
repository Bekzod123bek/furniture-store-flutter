import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/shop_storage.dart';

class PrefsShopStorage implements ShopStorage {
  PrefsShopStorage(this._prefs);

  static const _favoritesKey = 'favorites';
  static const _cartKey = 'cart';
  static const _ordersKey = 'orders';

  final SharedPreferences _prefs;

  @override
  List<String> loadFavorites() => _prefs.getStringList(_favoritesKey) ?? [];

  @override
  Future<void> saveFavorites(List<String> ids) =>
      _prefs.setStringList(_favoritesKey, ids);

  @override
  List<Map<String, dynamic>> loadCart() => _readList(_cartKey);

  @override
  Future<void> saveCart(List<Map<String, Object>> items) =>
      _prefs.setString(_cartKey, jsonEncode(items));

  @override
  List<Map<String, dynamic>> loadOrders() => _readList(_ordersKey);

  @override
  Future<void> saveOrders(List<Map<String, Object>> orders) =>
      _prefs.setString(_ordersKey, jsonEncode(orders));

  List<Map<String, dynamic>> _readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    } on FormatException {
      return [];
    }
  }
}
