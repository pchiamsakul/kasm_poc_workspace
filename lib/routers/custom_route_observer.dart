import 'package:flutter/material.dart';

class CustomRouteObserver<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    /// Check route.settings.name != null for popping bottomsheet or dialog
    /// Will only trigger when pushed page
    /// WARNING: will not trigger this action too if page doesn't have a name
    if (route.settings.name != previousRoute?.settings.name && route.settings.name != null) {
      super.didPop(route, previousRoute);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    /// Check route.settings.name != null for pushing bottomsheet or dialog
    /// Will only trigger when pushed page
    /// WARNING: will not trigger this action too if page doesn't have a name
    if (route.settings.name != previousRoute?.settings.name && route.settings.name != null) {
      super.didPush(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    /// Check route.settings.name != null for replacing bottomsheet or dialog
    /// Will only trigger when pushed page
    /// WARNING: will not trigger this action too if page doesn't have a name
    if (newRoute?.settings.name != oldRoute?.settings.name && newRoute?.settings.name != null) {
      super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }
}
