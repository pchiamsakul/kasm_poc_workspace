import 'package:flutter/material.dart';

class OnboardingDotIndicatorWidget extends StatelessWidget {
  const OnboardingDotIndicatorWidget({
    super.key,
    required this.total,
    required this.current,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int total;
  final int current;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isFilled = index <= current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isFilled ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }
}
