import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currencyFormat = NumberFormat.currency(symbol: 'KES ', decimalDigits: 2);
  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy HH:mm');
  static final _phoneFormat = NumberFormat('#,###');

  static String currency(double amount) => _currencyFormat.format(amount);

  static String date(DateTime date) => _dateFormat.format(date);

  static String dateTime(DateTime dateTime) => _dateTimeFormat.format(dateTime);

  static String phone(String phone) {
    if (phone.length == 10 && phone.startsWith('0')) {
      return '+254 ${phone.substring(1, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';
    }
    return phone;
  }

  static String percentage(double value) => '${value.toStringAsFixed(1)}%';

  static String number(int value) => _phoneFormat.format(value);

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
