import 'package:flutter/material.dart';

class ConditionalWrapper extends StatelessWidget {
  const ConditionalWrapper({
    super.key,
    required this.wrap,
    required this.wrapperBuilder,
    required this.child,
  });

  final Widget child;
  final Widget Function(Widget child) wrapperBuilder;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    if (wrap) {
      return wrapperBuilder(child);
    }
    return child;
  }
}
