import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CustomFormField<T> extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.formFieldKey,
    required this.value,
    this.validator,
    required this.child,
  });

  final GlobalKey<FormFieldState>? formFieldKey;
  final T value;
  final FormFieldValidator<T>? validator;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: formFieldKey,
      initialValue: value,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            if (state.errorText != null)
              Text(
                state.errorText!,
                style: context.theme.inputDecorationTheme.errorStyle,
              ).paddingOnly(
                left: context.theme.inputDecorationTheme.contentPadding!
                    .resolve(Directionality.of(context))
                    .left,
                top: 8,
              ),
          ],
        );
      },
      validator: validator,
    );
  }
}
