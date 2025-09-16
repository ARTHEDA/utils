import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:utils/src/utils/extensions/date_extensions.dart';

class AppValidators extends FormBuilderValidators {
  static FormFieldValidator<String> datePastWithFormat({
    String format = 'dd.MM.yyyy',
    bool checkNullOrEmpty = true,
  }) {
    return DatePastValidatorWithFormat(
      format: format,
      checkNullOrEmpty: checkNullOrEmpty,
    ).validate;
  }
}

class DatePastValidatorWithFormat extends BaseValidator<String> {
  const DatePastValidatorWithFormat({
    super.errorText,
    super.checkNullOrEmpty,
    required this.format,
  });

  final String format;

  @override
  String get translatedErrorText => FormBuilderLocalizations.current.dateMustBeInThePastErrorText;

  @override
  String? validateValue(String valueCandidate) {
    final date = valueCandidate.toDateTime(format);
    return date != null && date.isBefore(DateTime.now()) ? null : errorText;
  }
}
