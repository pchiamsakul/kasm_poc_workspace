import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/constant/k_color.dart';
import 'package:kasm_poc_workspace/core/constant/k_text_style.dart';

class LoadingDialog extends StatelessWidget {
  final Color backdropColor;
  final Function()? onCancel;

  const LoadingDialog({super.key, this.backdropColor = Colors.black54, this.onCancel});

  static Widget stream(
    Stream<bool> stream, {
    Function(bool)? onChanged,
    Function()? onCancel,
    Color? backdropColor,
  }) {
    return StreamBuilder<bool>(
        stream: stream,
        initialData: false,
        builder: (ctx, snapshot) {
          if (onChanged != null) {
            onChanged(snapshot.data!);
          }
          return snapshot.data == false
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : LoadingDialog(
                  backdropColor: backdropColor ?? Colors.transparent,
                  onCancel: onCancel,
                );
        });
  }

  static Widget loadingWidget() {
    return const SizedBox(
      width: 42,
      height: 42,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(KColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          OverflowBox(
            alignment: Alignment.center,
            minWidth: screenSize.width + 150.0,
            minHeight: screenSize.height + 150.0,
            maxWidth: screenSize.width + 150.0,
            maxHeight: screenSize.height + 150.0,
            child: Container(
              color: backdropColor,
              child: Center(child: loadingWidget()),
            ),
          ),
          if (onCancel != null)
            Positioned(
              bottom: 24,
              left: (screenSize.width / 2) - 16,
              child: InkWell(
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                onTap: onCancel,
                child: Text(
                  "cancel",
                  style: KTextStyles.body4.copyWith(
                    color: KColors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
