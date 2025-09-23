import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IntlDefaultLocalizationWrapper extends StatefulWidget {
  const IntlDefaultLocalizationWrapper({super.key, required this.child});

  static Widget builder(BuildContext context, Widget? child) {
    return IntlDefaultLocalizationWrapper(child: child ?? const SizedBox());
  }

  final Widget child;

  @override
  State<IntlDefaultLocalizationWrapper> createState() => _IntlDefaultLocalizationWrapperState();
}

class _IntlDefaultLocalizationWrapperState extends State<IntlDefaultLocalizationWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
