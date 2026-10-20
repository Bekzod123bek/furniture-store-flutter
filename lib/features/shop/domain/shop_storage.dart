/// Local persistence for favorites, cart and orders.
abstract class ShopStorage {
  List<String> loadFavorites();
  Future<void> saveFavorites(List<String> ids);

  List<Map<String, dynamic>> loadCart();
  Future<void> saveCart(List<Map<String, Object>> items);

  List<Map<String, dynamic>> loadOrders();
  Future<void> saveOrders(List<Map<String, Object>> orders);
}
