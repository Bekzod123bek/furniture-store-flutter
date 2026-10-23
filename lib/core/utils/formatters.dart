import 'package:intl/intl.dart';

final _money = NumberFormat.currency(
  locale: 'en_US',
  symbol: r'$',
  decimalDigits: 0,
);

/// Prices are kept in US dollars.
String formatMoney(num value) => _money.format(value);

/// Date and time in the given language, for example `24 okt 2026, 15:30`.
String formatDateTime(DateTime date, String locale) =>
    DateFormat('d MMM yyyy, HH:mm', locale).format(date);

String formatDate(DateTime date, String locale) =>
    DateFormat('d MMM yyyy', locale).format(date);
