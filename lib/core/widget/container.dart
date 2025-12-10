import 'package:flutter/material.dart';

class CircleContainer extends Container {
  CircleContainer({
    super.key,
    super.alignment,
    super.padding,
    Color? color,
    super.foregroundDecoration,
    Color strokeColor = Colors.transparent,
    double strokeWidth = 0,
    super.constraints,
    super.margin,
    super.transform,
    super.width,
    super.height,
    super.transformAlignment,
    super.child,
    super.clipBehavior = Clip.hardEdge,
    List<BoxShadow>? shadow,
  }) : super(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: strokeWidth, color: strokeColor),
            color: color,
            boxShadow: shadow,
          ),
        );
}

class RoundContainer extends Container {
  RoundContainer({
    super.key,
    super.alignment,
    super.padding,
    Color? color,
    double radius = 8.0,
    super.foregroundDecoration,
    super.constraints,
    super.margin,
    super.transform,
    super.width,
    super.height,
    Color strokeColor = Colors.transparent,
    double strokeWidth = 0,
    super.transformAlignment,
    super.child,
    super.clipBehavior = Clip.hardEdge,
    List<BoxShadow>? shadow,
  }) : super(
          decoration: BoxDecoration(
              color: color,
              border: Border.all(width: strokeWidth, color: strokeColor),
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
              boxShadow: shadow),
        );

  RoundContainer.only({
    super.key,
    super.alignment,
    super.padding,
    Color? color,
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
    super.foregroundDecoration,
    super.constraints,
    super.margin,
    super.transform,
    super.width,
    super.height,
    super.transformAlignment,
    super.child,
    super.clipBehavior,
    List<BoxShadow>? shadow,
  }) : super(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeft),
                topRight: Radius.circular(topRight),
                bottomLeft: Radius.circular(bottomLeft),
                bottomRight: Radius.circular(bottomRight),
              ),
              boxShadow: shadow),
        );
}
