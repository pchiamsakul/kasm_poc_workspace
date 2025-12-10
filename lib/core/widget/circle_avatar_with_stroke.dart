import 'package:flutter/material.dart';

class CircleAvatarWithStroke extends StatelessWidget {
  final ImageProvider image;
  final Color strokeColor;
  final double strokeWidth;
  final double? radius;

  const CircleAvatarWithStroke({
    required this.image,
    this.radius,
    this.strokeColor = const Color(0xFFF1C0A0),
    this.strokeWidth = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: radius == null
              ? CircleAvatar(radius: radius, backgroundColor: strokeColor)
              : CircleAvatar(radius: (radius ?? 0) + strokeWidth, backgroundColor: strokeColor),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(strokeWidth),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: image,
            ),
          ),
        ),
      ],
    );
  }
}
