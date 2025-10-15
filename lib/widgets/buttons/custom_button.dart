import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utils/src/extensions/closures.dart';
import 'package:utils/widgets/icons/svg_icon.dart';
import 'package:utils/widgets/loaders/loading.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.text,
    this.icon,
    this.childWidget,
    this.loadingWidget,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.iconColor,
    this.disabledIconColor,
    this.textStyle,
    this.textAlign,
    this.isLoading = false,
    this.height,
    this.width,
    this.iconGap,
    this.padding,
    this.shape,
    this.iconHeight,
    this.iconAlignment = IconAlignment.end,
  });

  final String? text;
  final String? icon;
  final Widget? childWidget;
  final Widget? loadingWidget;

  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? iconColor;
  final Color? disabledIconColor;

  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? height;
  final double? width;
  final double? iconGap;
  final double? iconHeight;
  final EdgeInsets? padding;
  final OutlinedBorder? shape;
  final IconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    var style = context.theme.textButtonTheme.style;
    style = ButtonStyle(
      backgroundColor: _CustomButtonDefaultColor(
        backgroundColor,
        disabledBackgroundColor,
        style?.backgroundColor,
      ),
      foregroundColor: _CustomButtonDefaultColor(
        foregroundColor,
        disabledForegroundColor,
        style?.foregroundColor,
      ),
      iconColor: _CustomButtonDefaultColor(
        iconColor ?? foregroundColor,
        disabledIconColor ?? disabledForegroundColor,
        style?.iconColor,
      ),
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      padding: ButtonStyleButton.allOrNull(padding),
      shape: ButtonStyleButton.allOrNull(shape),
      textStyle: ButtonStyleButton.allOrNull(textStyle),
      visualDensity: VisualDensity.standard,
    ).merge(style);
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: style,
        onPressed: isLoading ? null : onPressed,
        child: AnimatedSwitcher(
          duration: 100.milliseconds,
          child: IndexedStack(
            alignment: Alignment.center,
            key: ValueKey(isLoading),
            index: isLoading ? 0 : 1,
            children: [
              if (loadingWidget != null)
                loadingWidget!
              else
                Loading(
                  color: style.iconColor?.resolve({WidgetState.disabled}),
                  size: iconHeight ?? style.iconSize?.resolve({WidgetState.disabled}) ?? 10,
                ),
              if (childWidget != null)
                childWidget!
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (text != null)
                      Flexible(
                        child: Text(
                          text!,
                          maxLines: 2,
                          textAlign: textAlign,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (text != null && icon != null) SizedBox(width: iconGap ?? 0),
                    if (icon != null)
                      SvgIcon(
                        icon!,
                        height: iconHeight,
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

class _CustomButtonDefaultColor extends WidgetStateProperty<Color?> {
  _CustomButtonDefaultColor(this.color, this.disabled, this.theme);

  final Color? color;
  final Color? disabled;
  final WidgetStateProperty<Color?>? theme;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabled ?? theme?.resolve(states);
    }
    return color ?? theme?.resolve(states);
  }
}
