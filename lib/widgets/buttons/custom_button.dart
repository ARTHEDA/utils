import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utils/src/extensions/closures.dart';
import 'package:utils/widgets/icons/svg_icon.dart';
import 'package:utils/widgets/loaders/loading.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.isLoading = false,
    this.height,
    this.width,
    this.iconGap,
    this.padding,
    this.shape,
    this.iconSize,
    this.iconAlignment = IconAlignment.end,
  });

  final String? text;
  final String? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? height;
  final double? width;
  final double? iconGap;
  final double? iconSize;
  final EdgeInsets? padding;
  final OutlinedBorder? shape;
  final IconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final style = context.theme.textButtonTheme.style;
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          side: BorderSide.none,
          padding: padding,
          foregroundColor: foregroundColor,
          shape: shape,
        ),
        onPressed: isLoading ? null : onPressed,
        child: AnimatedSwitcher(
          duration: 100.milliseconds,
          child: IndexedStack(
            alignment: Alignment.center,
            key: ValueKey(isLoading),
            index: isLoading ? 0 : 1,
            children: [
              Loading(color: style?.foregroundColor?.resolve({WidgetState.disabled})),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (text != null)
                    Flexible(
                      child: Text(
                        text!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle?.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  if (text != null && icon != null) SizedBox(width: iconGap ?? 0),
                  if (icon != null)
                    SvgIcon(
                      icon!,
                      height: iconSize,
                      color: foregroundColor ??
                          style?.foregroundColor?.resolve({WidgetState.selected}),
                    ),
                ].let(
                  (l) => iconAlignment == IconAlignment.end ? l : l.reversed.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
