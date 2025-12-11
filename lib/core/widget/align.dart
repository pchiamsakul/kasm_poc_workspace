import 'package:flutter/cupertino.dart';

class TopRight extends Align {
  const TopRight({super.key, required super.child})
      : super(
          alignment: Alignment.topRight,
        );
}

class TopCenter extends Align {
  const TopCenter({super.key, required super.child})
      : super(
          alignment: Alignment.topCenter,
        );
}

class TopLeft extends Align {
  const TopLeft({super.key, required super.child})
      : super(
          alignment: Alignment.topLeft,
        );
}

class CenterRight extends Align {
  const CenterRight({super.key, required super.child})
      : super(
          alignment: Alignment.centerRight,
        );
}

class CenterLeft extends Align {
  const CenterLeft({super.key, required super.child})
      : super(
          alignment: Alignment.centerLeft,
        );
}

class BottomLeft extends Align {
  const BottomLeft({super.key, required super.child})
      : super(
          alignment: Alignment.bottomLeft,
        );
}

class BottomRight extends Align {
  const BottomRight({super.key, required super.child})
      : super(
          alignment: Alignment.bottomRight,
        );
}

class BottomCenter extends Align {
  const BottomCenter({super.key, required super.child})
      : super(
          alignment: Alignment.bottomCenter,
        );
}
