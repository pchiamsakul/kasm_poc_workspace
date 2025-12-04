import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/helper/provider.dart';
import 'package:kasm_poc_workspace/features/activity/pages/setting_view_model.dart';

class SettingItemWidget extends StatelessWidget {
  final String title;

  const SettingItemWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.of<SettingViewModel>();
    final viewModel2 = context.of<SettingViewModel2>();
    return Row(
      children: [
        StreamBuilder(
          stream: viewModel.publishStream,
          builder: (context, asyncSnapshot) {
            return Text(asyncSnapshot.data ?? "unknown");
          },
        ),
        InkWell(onTap: viewModel.changeTitle, child: Text(viewModel2.title2)),
      ],
    );
  }
}
