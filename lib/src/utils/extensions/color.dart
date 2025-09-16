import 'package:flutter/material.dart';

extension TransparentX on Color {
  Color get transparent => withOpacity(0);
}
