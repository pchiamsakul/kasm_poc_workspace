import 'package:flutter/widgets.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/app_page_route_builder.dart';
import 'package:kasm_poc_workspace/core/routers/navable.dart';
import 'package:kasm_poc_workspace/core/routers/router_action.dart';
import 'package:kasm_poc_workspace/core/routers/router_interceptor.dart';
import 'package:kasm_poc_workspace/core/routers/router_name.dart';

class NavigationRouter {
  static Route<dynamic>? router(RouteSettings settings) {
    try {
      var routName = settings.name ?? "/";
      var appNavigatorConfiguration = settings.arguments as AppNavigatorConfiguration?;
      if (routName == "/") {
        routName = RouterName.HomePage;
      }

      if (settings.arguments == null && appNavigatorConfiguration == null) {
        var uri = Uri.parse("http://local/$routName");
        if (uri.pathSegments.isNotEmpty) {
          routName = uri.pathSegments[0];
        }
        if (uri.queryParameters.isNotEmpty) {
          appNavigatorConfiguration = AppNavigatorConfiguration(arguments: uri.queryParameters);
        }
      }

      var newRoute = routName;
      Iterable<RouterInterceptor> list = <RouterInterceptor>[];
      try {
        list = getIt.getAll<RouterInterceptor>();
      } catch (e) {
        // do nothing
      }
      for (final value in list) {
        if (value.check(newRoute)) {
          final resultRoute = value
              .proceed(newRoute, appNavigatorConfiguration)
              .map(
                resume: (result) {
                  return newRoute;
                },
                next: (result) {
                  return result.newRoute;
                },
                stop: (result) {
                  return null;
                },
              );

          if (resultRoute == null) {
            return null;
          } else {
            newRoute = resultRoute;
          }
        }
      }

      var navAble = getIt<NavAble>(instanceName: newRoute);
      final widget = navAble.get(appNavigatorConfiguration?.arguments);
      return AppPageRouteBuilder.route(
        name: settings.name,
        // name: newRoute,
        transitionType: appNavigatorConfiguration?.transition,
        builder: (ctx) {
          return widget;
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
