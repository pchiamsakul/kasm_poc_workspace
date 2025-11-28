import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/routers/app_page_route_builder.dart';

class AppNavigatorConfiguration {
  RouteTransition? transition;
  dynamic arguments;

  AppNavigatorConfiguration({this.transition, this.arguments});
}

abstract class AppNavigator {
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    dynamic arguments,
    RouteTransition? transition,
  });

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    dynamic arguments,
    RouteTransition? transition,
  });

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    dynamic arguments,
    RouteTransition? transition,
  });

  void pop<T extends Object?>([T? result]);

  bool canPop();

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey);

  void setRouteObserver(RouteObserver<ModalRoute<void>> routeObserver);

  RouteObserver<ModalRoute<void>>? get routeObserver;

  NavigatorState? get currentState;
}

@Singleton(as: AppNavigator)
class AppNavigatorImp extends AppNavigator {
  GlobalKey<NavigatorState>? navigatorKey;

  NavigatorState? get _currentState => navigatorKey?.currentState;

  @override
  void pop<T extends Object?>([T? result]) {
    _currentState?.pop(result);
  }

  @override
  @optionalTypeArgs
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    arguments,
    RouteTransition? transition,
  }) async {
    final result = await _currentState?.pushNamed<T>(
      routeName,
      arguments: AppNavigatorConfiguration(arguments: arguments, transition: transition),
    );

    return result;
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    arguments,
    RouteTransition? transition,
  }) async {
    final result = await _currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: AppNavigatorConfiguration(arguments: arguments, transition: transition),
    );

    return result;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    arguments,
    RouteTransition? transition,
  }) async {
    final navResult = await _currentState?.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: AppNavigatorConfiguration(arguments: arguments, transition: transition),
    );

    return navResult;
  }

  @override
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    if (this.navigatorKey != navigatorKey) {
      // ignore: invalid_use_of_protected_member
      _currentState?.dispose();
    }

    this.navigatorKey = navigatorKey;
  }

  @override
  void setRouteObserver(RouteObserver<ModalRoute<void>> routeObserver) {
    this.routeObserver = routeObserver;
  }

  @override
  RouteObserver<ModalRoute<void>>? routeObserver;

  @override
  NavigatorState? get currentState => navigatorKey?.currentState;

  @override
  bool canPop() {
    return _currentState?.canPop() ?? false;
  }
}
