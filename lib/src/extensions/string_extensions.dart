import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:utils/src/extensions/closures.dart';

extension StringExtensions on String {
  String get hardcoded => this;
}

extension PhoneExtension on String? {
  String? get maskedPhone => let(toMaskedPhone);

  String? get unmaskedPhone {
    if (this == null || this!.isEmpty) {
      return null;
    }
    final phone = this!.startsWith('8') ? this!.replaceFirst('8', '+7') : this;
    return '+${toNumericString(phone)}';
  }
}

String toMaskedPhone(String phone) {
  final masked = formatAsPhoneNumber(phone);
  if (masked != null) {
    return masked;
  }
  return phone;
}
