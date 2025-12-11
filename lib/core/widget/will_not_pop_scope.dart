import 'package:flutter/material.dart';

class WillNotPopScope extends StatelessWidget {
  final Widget child;

  const WillNotPopScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
    );
  }
}
