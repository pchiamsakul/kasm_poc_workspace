import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/widget/loading_dialog.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final Stream<bool>? isLoading;
  final Function()? onCancelLoading;

  const LoadingContainer({
    super.key,
    required this.child,
    this.isLoading,
    this.onCancelLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading != null) LoadingDialog.stream(isLoading!, onCancel: onCancelLoading)
      ],
    );
  }
}
