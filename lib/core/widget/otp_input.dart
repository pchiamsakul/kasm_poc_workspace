import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/constant/k_text_style.dart';
import 'package:kasm_poc_workspace/core/widget/container.dart';

class OtpInput extends StatefulWidget {
  final int length;
  final Function(String value)? onTextComplete;
  final double spaceSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;

  const OtpInput({
    super.key,
    this.length = 6,
    this.onTextComplete,
    this.horizontalPadding = 14,
    this.spaceSize = 8,
    this.verticalPadding = 12,
    this.fontSize = 24,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (index) {
              return buildOtpDisplay(index);
            }),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Opacity(
              opacity: 0.0,
              child: TextField(
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _textController,
                onChanged: (value) {
                  if (value.length == widget.length) {
                    FocusScope.of(context).nextFocus();
                    widget.onTextComplete?.call(value);
                  }
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  RoundContainer buildOtpDisplay(int index) {
    final text = _getText(index);
    return RoundContainer(
      radius: 12,
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: widget.verticalPadding,
      ),
      color: KColors.white,
      strokeWidth: 2.0,
      strokeColor: index == _textController.text.length ? KColors.primary : KColors.gallery,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'M',
            textAlign: TextAlign.center,
            style: KTextStyles.body2.copyWith(fontSize: widget.fontSize, color: Colors.transparent),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: KTextStyles.body2.copyWith(fontSize: widget.fontSize, color: KColors.primary),
          ),
        ],
      ),
    );
  }

  String _getText(int index) {
    try {
      return _textController.text[index];
    } catch (e) {
      return "";
    }
  }
}
