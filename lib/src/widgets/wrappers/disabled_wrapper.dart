import 'package:flutter/material.dart';

class DisabledWrapper extends StatelessWidget {
  const DisabledWrapper({
    super.key,
    this.disabling = false,
    required this.child,
  });

  final bool disabling;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabling,
      child: Opacity(
        opacity: disabling ? 0.5 : 1,
        child: child,
      ),
    );
  }
}
