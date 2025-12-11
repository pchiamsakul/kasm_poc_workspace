import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';

class PageIndicator extends StatefulWidget {
  final double dotSize;
  final double margin;
  final double indexWidth;
  final PageController pageController;
  final int length;
  final Color activeColor;
  final Color color;

  const PageIndicator({
    super.key,
    required this.length,
    required this.pageController,
    this.dotSize = 6,
    this.margin = 4,
    this.indexWidth = 13,
    this.activeColor = KColors.primary,
    this.color = KColors.lightGrey,
  });

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> with SingleTickerProviderStateMixin {
  late final Animation _animation;
  late final AnimationController _controller;
  late final VoidCallback _pageListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.pageController.jumpToPage(widget.length * 10);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.length.toDouble()).animate(_controller);

    _pageListener = () {
      final page = (widget.pageController.page ?? 0) % (widget.length);
      if (page == 0) {
        widget.pageController.jumpToPage(widget.length * 10);
      }
      _controller.value = (page) / widget.length;
    };
    widget.pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: _PageIndicatorPainter(
                widget.dotSize,
                widget.margin,
                widget.length,
                widget.indexWidth,
                _animation.value,
                widget.color,
                widget.activeColor,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PageIndicatorPainter extends CustomPainter {
  final _paint = Paint();
  final double dotSize;
  final double margin;
  final double indexWidth;
  final double position;
  final int length;
  final Color color;
  final Color activeColor;

  _PageIndicatorPainter(
    this.dotSize,
    this.margin,
    this.length,
    this.indexWidth,
    this.position,
    this.color,
    this.activeColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color;
    final width = dotSize * length + margin * (length - 1.0) + indexWidth;
    final r = dotSize / 2;
    for (int i = 0; i < length; i++) {
      final reduce = i + 1 - position;
      final increase = position - i;
      if (position > length - 1) {
        final inWidthRight = (position - (length - 1)) * indexWidth;
        final halfIndexRight = inWidthRight;
        final shift = halfIndexRight;
        if (i != length - 1 && i != 0) {
          final Offset center = Offset(-width / 2.0 + r + dotSize * i + margin * i + shift, 0);
          _paint.color = color;
          canvas.drawCircle(center, r, _paint);
        } else {
          final inWidthLeft = reduce * indexWidth + dotSize;
          final halfIndexLeft = inWidthLeft / 2;
          final Offset centerLeft =
              Offset(-width / 2.0 + dotSize * i + margin * i + halfIndexLeft + shift, 0);
          if (i != 0) {
            _paint.color = toInactiveColor(position - (length - 1));
            canvas.drawRRect(
                RRect.fromLTRBR(centerLeft.dx - halfIndexLeft, -r, centerLeft.dx + halfIndexLeft, r,
                    Radius.circular(r)),
                _paint);
          } else {
            final inWidthLeft = (1 - (length - position)) * indexWidth + dotSize;
            final halfIndexLeft = inWidthLeft / 2;
            final Offset centerLeft =
                Offset(-width / 2.0 + dotSize * i + margin * i + halfIndexLeft, 0);
            _paint.color = toActiveColor(position - (length - 1));
            canvas.drawRRect(
                RRect.fromLTRBR(centerLeft.dx - halfIndexLeft, -r, centerLeft.dx + halfIndexLeft, r,
                    Radius.circular(r)),
                _paint);
          }
        }
      } else if (i <= position && position < i + 1) {
        final inWidthLeft = reduce * indexWidth + dotSize;
        final inWidthRight = increase * indexWidth + dotSize;
        final halfIndexLeft = inWidthLeft / 2;
        final halfIndexRight = inWidthRight / 2;
        final Offset centerLeft =
            Offset(-width / 2.0 + dotSize * i + margin * i + halfIndexLeft, 0);
        _paint.color = toInactiveColor(increase);
        canvas.drawRRect(
            RRect.fromLTRBR(centerLeft.dx - halfIndexLeft, -r, centerLeft.dx + halfIndexLeft, r,
                Radius.circular(r)),
            _paint);
        if (i + 1 < length) {
          final Offset centerRight = Offset(
              -width / 2.0 + dotSize * (i) + margin * (i + 1) + halfIndexRight + inWidthLeft, 0);
          _paint.color = toActiveColor(increase);
          canvas.drawRRect(
              RRect.fromLTRBR(centerRight.dx - halfIndexRight, -r, centerRight.dx + halfIndexRight,
                  r, Radius.circular(r)),
              _paint);
        }
        i++;
      } else {
        var shift = 0.0;
        if (i > position + 1) {
          shift = indexWidth;
        }
        final Offset center = Offset(-width / 2.0 + r + dotSize * i + margin * i + shift, 0);
        _paint.color = color;
        canvas.drawCircle(center, r, _paint);
      }
    }
  }

  Color toInactiveColor(double increase) {
    return Color.fromRGBO(
      ((color.r * 255.0 * increase).round() + (activeColor.r * 255.0 * (1 - increase)).round())
          .clamp(0, 255),
      ((color.g * 255.0 * increase).round() + (activeColor.g * 255.0 * (1 - increase)).round())
          .clamp(0, 255),
      ((color.b * 255.0 * increase).round() + (activeColor.b * 255.0 * (1 - increase)).round())
          .clamp(0, 255),
      1,
    );
  }

  Color toActiveColor(double increase) {
    return Color.fromRGBO(
      ((color.r * 255.0 * (1 - increase)).round() + (activeColor.r * 255.0 * increase).round())
          .clamp(0, 255),
      ((color.g * 255.0 * (1 - increase)).round() + (activeColor.g * 255.0 * increase).round())
          .clamp(0, 255),
      ((color.b * 255.0 * (1 - increase)).round() + (activeColor.b * 255.0 * increase).round())
          .clamp(0, 255),
      1,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
