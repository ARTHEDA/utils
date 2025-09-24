import 'package:flutter/material.dart';
import 'package:utils/src/extensions/text_editing_controller_extensions.dart';

extension NList<T> on List<T>? {
  List<T>? get nullable => (this?.isEmpty ?? true) ? null : this;
}

extension NSet<T> on Set<T>? {
  Set<T>? get nullable => (this?.isEmpty ?? true) ? null : this;
}

extension NMap<T, K> on Map<T, K>? {
  Map<T, K>? get nullable => (this?.isEmpty ?? true) ? null : this;
}

extension NString on String? {
  String? get nullable {
    return (this?.trim().isEmpty ?? true) ? null : this;
  }
}

extension NNum<T extends num> on T? {
  T? get nullable => this == 0 ? null : this;
}

extension NTextController on TextEditingController? {
  String? get nullable => this?.trimmed.nullable;
}
