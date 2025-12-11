import 'package:flutter/material.dart';

class LoopPager extends StatelessWidget {
  final PageController controller;
  final int length;
  final Widget Function(int index) builder;
  final Function(int index)? handleOnPageChange;

  const LoopPager({
    super.key,
    required this.builder,
    required this.controller,
    required this.length,
    this.handleOnPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: length > 1 ? null : const NeverScrollableScrollPhysics(),
      controller: controller,
      scrollDirection: Axis.horizontal,
      onPageChanged: handleOnPageChange,
      itemBuilder: (BuildContext context, int rawIndex) {
        var index = rawIndex;
        if (length > 0) {
          index = rawIndex % length;
        } else {
          index = -1;
        }
        return index < 0 ? Container() : builder(index);
      },
    );
  }
}
