import 'package:flutter/material.dart';

class CrossFadeWrapper extends StatelessWidget {
  const CrossFadeWrapper({
    super.key,
    this.show = true,
    this.fullWidth = true,
    this.duration = const Duration(milliseconds: 200),
    required this.child,
  });

  final bool show;
  final bool fullWidth;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      firstChild: SizedBox(
        width: fullWidth ? double.infinity : null,
        child: child,
      ),
      secondChild: const SizedBox(
        width: double.infinity,
      ),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
