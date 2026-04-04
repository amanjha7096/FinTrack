import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  static String format(double amount) => _format.format(amount);
}