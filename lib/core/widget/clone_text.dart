import 'package:flutter/widgets.dart';

class CloneText extends StatefulWidget {
  final TextEditingController controller;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? Function(String text)? interceptor;

  const CloneText({
    super.key,
    required this.controller,
    this.style,
    this.textAlign,
    this.interceptor,
  });

  @override
  State<CloneText> createState() => _CloneTextState();
}

class _CloneTextState extends State<CloneText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.interceptor?.call(widget.controller.text) ?? widget.controller.text,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateText);
    super.dispose();
  }

  void _updateText() {
    setState(() {});
  }
}
