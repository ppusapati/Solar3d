class Validators {
  Validators._();

  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? number(String? value, [String field = 'Value']) {
    if (value == null || value.trim().isEmpty) return null;
    if (double.tryParse(value) == null) {
      return '$field must be a valid number';
    }
    return null;
  }

  static String? positiveNumber(String? value, [String field = 'Value']) {
    final numError = number(value, field);
    if (numError != null) return numError;
    if (value != null && value.isNotEmpty) {
      final num = double.tryParse(value);
      if (num != null && num <= 0) {
        return '$field must be positive';
      }
    }
    return null;
  }

  static String? latitude(String? value) {
    final numError = number(value, 'Latitude');
    if (numError != null) return numError;
    if (value != null && value.isNotEmpty) {
      final num = double.tryParse(value);
      if (num != null && (num < -90 || num > 90)) {
        return 'Latitude must be between -90 and 90';
      }
    }
    return null;
  }

  static String? longitude(String? value) {
    final numError = number(value, 'Longitude');
    if (numError != null) return numError;
    if (value != null && value.isNotEmpty) {
      final num = double.tryParse(value);
      if (num != null && (num < -180 || num > 180)) {
        return 'Longitude must be between -180 and 180';
      }
    }
    return null;
  }
}
