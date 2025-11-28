import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/constants/router_name.dart';
import 'package:kasm_poc_workspace/features/landing/pages/landing_page.dart';
import 'package:kasm_poc_workspace/routers/navable.dart';

@Named(RouterName.landingPage)
@Injectable(as: NavAble)
class LandingNavigator implements NavAble {
  @override
  Widget get(argument) => const LandingPage();
}
