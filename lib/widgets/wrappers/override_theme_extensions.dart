import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverrideThemeExtensions extends StatelessWidget {
  const OverrideThemeExtensions({
    super.key,
    required this.extensions,
    required this.child,
  });

  final Iterable<ThemeExtension> extensions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        extensions: [
          ...context.theme.extensions.values,
          ...extensions,
        ],
      ),
      child: child,
    );
  }
}
