enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled;

  static OrderStatus parse(String? name) => values.firstWhere(
    (s) => s.name == name,
    orElse: () => OrderStatus.processing,
  );
}
