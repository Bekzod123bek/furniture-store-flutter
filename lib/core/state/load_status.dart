/// Loading state shared by cubits that fetch data.
enum LoadStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading =>
      this == LoadStatus.initial || this == LoadStatus.loading;
}
