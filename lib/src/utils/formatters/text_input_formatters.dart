import 'dart:math';

import 'package:flutter/services.dart';

/// The class that provides methods for formatting text input.
class AppTextInputFormatters {
  const AppTextInputFormatters._();

  /// The formatter for entering a name.
  static TextInputFormatter nameFormatter() =>
      FilteringTextInputFormatter.allow(RegExp(r'[\sa-zA-Zа-яА-Я-]'));

  /// The formatter for entering a email.
  static TextInputFormatter emailFormatter() =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\-\d@_.]+'));

  static TextInputFormatter telegramFormatter() => TextInputFormatter.withFunction(
        (prev, current) {
          var value = current.text.replaceFirst('https://t.me/', '@');
          if (!value.startsWith('@')) {
            value = '@$value';
          }
          value = RegExp('^@|[0-9a-zA-Z_]+').allMatches(value).map((e) => e[0]!).join();
          return TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          );
        },
      );

  /// The formatter for entering a number
  static TextInputFormatter numberFormatter() => FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter maxLinesFormatter(int maxLines) => TextInputFormatter.withFunction((
        oldValue,
        newValue,
      ) {
        if (maxLines > 0) {
          final regEx = RegExp('^.*((\n?.*){0,${maxLines - 1}})');
          final newString = regEx.stringMatch(newValue.text) ?? '';

          final maxLength = newString.length;
          if (newValue.text.runes.length > maxLength) {
            final newSelection = newValue.selection.copyWith(
              baseOffset: min(newValue.selection.start, maxLength),
              extentOffset: min(newValue.selection.end, maxLength),
            );
            final iterator = RuneIterator(newValue.text);
            if (iterator.moveNext()) {
              for (var count = 0; count < maxLength; ++count) {
                if (!iterator.moveNext()) {
                  break;
                }
              }
            }
            final truncated = newValue.text.substring(0, iterator.rawIndex);
            return TextEditingValue(
              text: truncated,
              selection: newSelection,
            );
          }
          return newValue;
        }
        return newValue;
      });
}
