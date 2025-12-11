import 'package:flutter/material.dart';

class Line extends Container {
  factory Line.v({double width = 1, Color? color}) => Line._(
        width: width,
        color: color,
      );

  factory Line.h({double width = 1, Color? color}) => Line._(
        height: width,
        color: color,
      );

  Line._({super.width, super.height, Color? color}) : super(color: color ?? Colors.grey[400]);
}

class LineDash extends StatelessWidget {
  final double thickness;
  final double space;
  final Color color;
  final Axis direction;

  factory LineDash.h({
    double thickness = 1,
    double space = 5,
    Color color = const Color(0xFFBDBDBD),
  }) =>
      LineDash._(
        thickness: thickness,
        space: space,
        color: color,
        direction: Axis.horizontal,
      );

  factory LineDash.v({
    double thickness = 1,
    double space = 5,
    Color color = const Color(0xFFBDBDBD),
  }) =>
      LineDash._(
        thickness: thickness,
        space: space,
        color: color,
        direction: Axis.vertical,
      );

  const LineDash._({
    this.thickness = 1,
    this.space = 1,
    this.color = Colors.black,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = space;
        final dashHeight = thickness;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWidth : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
