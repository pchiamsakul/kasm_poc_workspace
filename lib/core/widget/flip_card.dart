import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final double aspectRatio;

  const FlipCard({super.key, required this.front, required this.back, this.aspectRatio = 1.75});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: angle),
          duration: const Duration(milliseconds: 300),
          builder: (BuildContext context, double val, __) {
            isBack = val < (pi / 2);
            return (Transform(
              //let's make the card flip by it's center
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: isBack
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: widget.front,
                      )
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: widget.back,
                        ),
                      ),
              ),
            ));
          }),
    );
  }
}
