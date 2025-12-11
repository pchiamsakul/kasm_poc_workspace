import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/helper/provider.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/activity/presentation/setting_view_model.dart';
import 'package:kasm_poc_workspace/features/activity/presentation/widget/setting_item_widget.dart';

@Named(RouterName.SettingPage)
@Injectable(as: NavAble)
class SettingPageNavAble implements NavAble {
  @override
  Widget get(dynamic arguments) {
    return const SettingPage();
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final viewModel = getIt<SettingViewModel>();
  final viewModel2 = getIt<SettingViewModel2>();

  @override
  void initState() {
    super.initState();
    viewModel.publishStream.listen((event) {
      // show popup
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      value: viewModel,
      child: Provider(
        value: viewModel2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                InkWell(onTap: () => viewModel.goToHome(), child: Text("Setting Page")),
                SettingItemWidget(title: "change language"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
