class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final pattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? idNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'ID number is required';
    if (value.length < 5) {
      return 'Enter a valid ID number';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Enter a valid amount greater than 0';
    }
    return null;
  }

  static String? positiveNumber(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    final number = double.tryParse(value.trim());
    if (number == null || number < 0) {
      return 'Enter a valid positive number';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) return 'Please confirm your password';
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
