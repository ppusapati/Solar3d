import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _dateTimeFormat = DateFormat('MMM d, yyyy HH:mm');
  static final _compactNumber = NumberFormat.compact();
  static final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  static String date(DateTime date) => _dateFormat.format(date);

  static String dateTime(DateTime date) => _dateTimeFormat.format(date);

  static String compactNumber(num value) => _compactNumber.format(value);

  static String currency(double value) => _currency.format(value);

  static String capacity(double kw) {
    if (kw >= 1000) {
      return '${(kw / 1000).toStringAsFixed(2)} MW';
    }
    return '${kw.toStringAsFixed(0)} kW';
  }

  static String distance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  static String area(double sqm) {
    if (sqm >= 10000) {
      return '${(sqm / 10000).toStringAsFixed(2)} ha';
    }
    return '${sqm.toStringAsFixed(0)} m\u00B2';
  }

  static String percentage(double value) => '${value.toStringAsFixed(1)}%';

  static String fileSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    }
    if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}
