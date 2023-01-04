import 'package:intl/intl.dart';

String convertToIdr(dynamic number, int decimalDigit) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  if (number.runtimeType != double) {
    number = double.parse(number == null ? 0.0 : number);
  }
  return currencyFormatter.format(number);
}
