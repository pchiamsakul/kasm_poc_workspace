import 'package:kasm_poc_workspace/core/routers/router_action.dart';

class RouterInterceptorName {}

abstract class RouterInterceptor {
  bool check(String routeName);

  RouterAction proceed(String routeName, dynamic arguments);
}
