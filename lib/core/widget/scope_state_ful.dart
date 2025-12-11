import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScopeStateful extends StatefulWidget {
  const ScopeStateful({super.key, required this.build});

  final Function(BuildContext context, ScopeStatefulState state) build;

  @override
  ScopeStatefulState createState() => ScopeStatefulState();
}

class ScopeStatefulState extends State<ScopeStateful> {
  dynamic tag;

  void updateWithTag([tag]) {
    setState(() {
      this.tag = tag;
    });
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, this);
  }
}
