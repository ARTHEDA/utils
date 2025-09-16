import 'package:flutter/cupertino.dart';

extension TextControllerHelpers on TextEditingController {
  String get trimmed => text.trim();
}
