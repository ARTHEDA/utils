import 'package:flutter/material.dart';

class DisabledWrapper extends StatelessWidget {
  const DisabledWrapper({
    super.key,
    this.disabling = true,
    this.opacity = 0.5,
    required this.child,
  });

  final bool disabling;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabling,
      child: Opacity(
        opacity: disabling ? opacity : 1,
        child: child,
      ),
    );
  }
}
