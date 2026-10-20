import 'package:intl/intl.dart';

final _money = NumberFormat.currency(
  locale: 'en_US',
  symbol: '\$',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy, HH:mm');

String money(num value) => _money.format(value);
String formatDate(DateTime date) => _date.format(date);
