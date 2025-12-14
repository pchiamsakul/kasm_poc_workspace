import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';
import 'package:kasm_poc_workspace/features/setting/presentation/setting_page.dart';

@Named(RouterName.SettingPage)
@Injectable(as: NavAble)
class SettingPageNavAble
    implements NavAble {
  @override
  Widget get(dynamic arguments) {
    return const SettingPage();
  }
}
