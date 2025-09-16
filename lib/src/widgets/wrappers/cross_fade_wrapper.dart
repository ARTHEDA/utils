import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CrossFadeWrapper extends StatelessWidget {
  const CrossFadeWrapper({
    super.key,
    this.show = true,
    this.fullWidth = true,
    required this.child,
  });

  final bool show;
  final bool fullWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: 200.milliseconds,
      firstChild: SizedBox(
        width: double.infinity,
        child: child,
      ),
      secondChild: const SizedBox(
        width: double.infinity,
      ),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
