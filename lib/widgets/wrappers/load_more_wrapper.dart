import 'package:flutter/material.dart';

class _LoadMoreWrapperInherited extends InheritedWidget {
  const _LoadMoreWrapperInherited({required super.child});

  @override
  bool updateShouldNotify(_LoadMoreWrapperInherited oldWidget) => false;
}

class LoadMoreWrapper extends StatefulWidget {
  const LoadMoreWrapper({
    super.key,
    required this.child,
    this.onLoadMore,
    this.offset = 600,
  });

  final Widget child;
  final VoidCallback? onLoadMore;
  final double offset;

  static bool at(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LoadMoreWrapperInherited>() != null;
  }

  @override
  State<LoadMoreWrapper> createState() => _LoadMoreWrapperState();
}

class _LoadMoreWrapperState extends State<LoadMoreWrapper> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - widget.offset) {
        widget.onLoadMore!.call();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LoadMoreWrapperInherited(
      child: PrimaryScrollController(
        controller: scrollController,
        child: widget.child,
      ),
    );
  }
}
