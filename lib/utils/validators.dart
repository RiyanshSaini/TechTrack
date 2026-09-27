class Validators {
  Validators._();

  static final _phoneRegex = RegExp(r'^[6-9]\d{9}$');

  /// Returns null if valid, or an error message if invalid.
  /// This is the exact signature TextFormField.validator expects.
  static String? phone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(trimmed)) return 'Enter a valid 10-digit phone number';
    return null;
  }

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}