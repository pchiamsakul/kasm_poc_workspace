import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/constants/router_name.dart';
import 'package:kasm_poc_workspace/features/home/page/home_page.dart';
import 'package:kasm_poc_workspace/routers/navable.dart';

@Named(RouterName.homePage)
@Injectable(as: NavAble)
class HomeNavigator implements NavAble {
  @override
  Widget get(argument) => const HomePage();
}
