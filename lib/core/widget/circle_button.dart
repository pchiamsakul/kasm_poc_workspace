import 'package:flutter/material.dart';

class CircleButton extends MaterialButton {
  const CircleButton({
    super.key,
    required void Function() super.onPressed,
    super.child,
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    super.color = Colors.transparent,
  }) : super(
            minWidth: 0,
            height: 0,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap);
}
