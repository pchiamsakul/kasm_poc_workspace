import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';

@Named(RouterName.ActivityPage)
@Injectable(as: NavAble)
class HomeNavigator implements NavAble {
  @override
  Widget get(argument) => const ActivityPage();
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
