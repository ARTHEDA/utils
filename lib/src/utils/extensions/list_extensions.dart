import 'package:flutter/material.dart';

extension JoinWidget on List<Widget> {
  List<Widget> joinWidget(Widget separator) {
    if (length < 2) {
      return this;
    }
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      if (i > 0) {
        result.add(separator);
      }
      result.add(this[i]);
    }
    return result;
  }
}

extension ReplaceL<T> on Iterable<T> {
  /// Returns copy
  Iterable<T> replaceWhere(bool Function(T element) test, T replacement) {
    return map((e) {
      if (test(e)) {
        return replacement;
      }
      return e;
    });
  }
}
