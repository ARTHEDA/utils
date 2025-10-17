import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CustomFormField<T> extends FormField<T> {
  CustomFormField({
    super.key,
    required T value,
    super.validator,
    required Widget child,
  }) : super(
          initialValue: value,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                child,
                if (state.errorText != null)
                  Builder(
                    builder: (context) {
                      return Text(
                        state.errorText!,
                        style: context.theme.inputDecorationTheme.errorStyle,
                      ).paddingOnly(
                        left: context.theme.inputDecorationTheme.contentPadding!
                            .resolve(Directionality.of(context))
                            .left,
                        top: 8,
                      );
                    },
                  ),
              ],
            );
          },
        );

  @override
  FormFieldState<T> createState() => _CustomFormFieldState<T>();
}

class _CustomFormFieldState<T> extends FormFieldState<T> {
  @override
  void didUpdateWidget(CustomFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
