/// Promo codes and their discount rates. Kept in code for now; move them to
/// Firestore when marketing needs to change them without a release.
abstract final class PromoCodes {
  static const _rates = {'SALE10': 0.10, 'WELCOME20': 0.20};

  static String normalize(String code) => code.trim().toUpperCase();

  /// Discount rate (0.1 = 10%) for [code], or `null` if the code is unknown.
  static double? rateFor(String code) => _rates[normalize(code)];

  static bool isValid(String code) => rateFor(code) != null;
}
