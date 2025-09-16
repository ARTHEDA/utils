import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:utils/src/api/types.dart';
import 'package:utils/src/utils/extensions/object_extensions.dart';
import 'package:utils/src/widgets/loaders/loading.dart';
import 'package:utils/src/widgets/wrappers/load_more_wrapper.dart';

class StateProcessingWidget<T> extends StatelessWidget {
  const StateProcessingWidget({
    super.key,
    required this.builder,
    this.errorBuilder,
    this.pendingBuilder,
    this.emptyBuilder,
    required this.rxv,
    this.height = 400,
    this.defaultEmptyText = '',
    this.isSliver = false,
  });

  final Widget Function(BuildContext context, T state) builder;
  final Widget Function(BuildContext context, Err error)? errorBuilder;
  final Widget Function(BuildContext context, T state)? pendingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final RxV<T> rxv;
  final double height;
  final String defaultEmptyText;
  final bool isSliver;

  bool _isEmpty(Object? value) {
    return value == null ||
        (value.cast<Iterable>()?.isEmpty ?? value.cast<Map>()?.isEmpty ?? false);
  }

  Widget sliverOr(Widget child) {
    return isSliver ? child.sliverBox : child;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pending = rxv.isPending;
      final error = rxv.isError;
      final empty = _isEmpty(rxv.data);

      final pendingWidget =
          pendingBuilder?.call(context, rxv.data) ?? Loading.withHeight(height: height);

      if (pending && empty) {
        return sliverOr(pendingWidget);
      }
      if (error && errorBuilder != null) {
        return errorBuilder!(context, rxv.error);
      }
      if (empty) {
        final emptyWidget = emptyBuilder?.call(context) ??
            SizedBox(
              height: height,
              child: Center(
                child: Text(defaultEmptyText),
              ),
            );
        return sliverOr(emptyWidget);
      }
      if (LoadMoreWrapper.at(context) && pending && isSliver) {
        return MultiSliver(
          children: [
            builder(context, rxv.data),
            pendingWidget.sliverBox,
          ],
        );
      }
      return builder(context, rxv.data);
    });
  }
}
