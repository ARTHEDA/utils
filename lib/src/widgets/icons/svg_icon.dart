import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon, {
    super.key,
    this.packageName,
    this.color,
    this.width,
    this.height,
    this.size,
    this.useColor = true,
  }) : assert(
          size == null || (width == null && height == null),
          'Use one of size or width and height',
        );

  final String icon;
  final String? packageName;
  final Color? color;
  final bool useColor;
  final double? width;
  final double? height;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconSize = width != null || height != null ? null : size ?? iconTheme.size;
    final iconColor = color ?? iconTheme.color;

    return SizedBox.square(
      dimension: iconSize,
      child: SvgPicture.asset(
        icon,
        package: packageName,
        colorFilter: !useColor || iconColor == null
            ? null
            : ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
        width: iconSize ?? width,
        height: iconSize ?? height,
      ),
    );
  }
}
