import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    this.color,
    this.size = 20,
  });

  static Widget withHeight({required double height, Color? color, double size = 20}) {
    return SizedBox(
      height: height,
      child: Center(
        child: Loading(
          size: size,
          color: color,
        ),
      ),
    );
  }

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CupertinoActivityIndicator(
        radius: size / 2,
        color: color,
      ),
    );
  }
}
