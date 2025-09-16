import 'package:flutter/material.dart';

extension JoinWidget on Iterable<Widget> {
  List<Widget> joinWidget(Widget separator) {
    return map((e) => [separator, e]).expand((e) => e).skip(1).toList();
  }
}

extension ReplaceL<T> on Iterable<T> {
  Iterable<T> replaceWhere(bool Function(T element) test, T Function(T) replacement) {
    return map((e) {
      if (test(e)) {
        return replacement(e);
      }
      return e;
    });
  }
}
