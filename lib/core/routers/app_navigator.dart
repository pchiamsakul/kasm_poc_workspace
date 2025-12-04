import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/core/routers/app_page_route_builder.dart';
import 'package:synchronized/synchronized.dart';
import 'package:url_launcher/url_launcher_string.dart';


class AppGlobalDialogConfig {
  final String? title;
  final String? description;
  final String? primaryText;
  final String? secondaryText;
  final bool isAllowDismiss;
  final Function()? primaryPressed;
  final Function()? secondaryPressed;

  const AppGlobalDialogConfig({
    this.primaryText,
    this.secondaryText,
    this.isAllowDismiss = true,
    this.title,
    this.description,
    this.primaryPressed,
    this.secondaryPressed,
  });
}

abstract class AppNavigatorListenState<T extends StatefulWidget, VM extends BaseViewModel>
    extends State<T> with WidgetsBindingObserver {
  void onPause() {}

  void onPauseFromPush() {}

  void onResume() {}

  void onResumeFromPop() {}

  late final VM viewModel;

  void initViewModel() {
    viewModel = getIt();
  }

  @override
  void initState() {
    initViewModel();
    viewModel.addOnNavChangedListener(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onResume();
    } else if (state == AppLifecycleState.paused) {
      onPause();
    }
  }
}

class AppNavigatorConfiguration {
  RouteTransition? transition;
  dynamic arguments;

  AppNavigatorConfiguration({this.transition, this.arguments});
}

@singleton
class AppNavigator {
  GlobalKey<NavigatorState>? navigatorKey;
  final PublishSubject<AppGlobalDialogConfig> globalError = PublishSubject();

  final _onNavChangedListeners = <AppNavigatorListenState>[];
  final Map<String, dynamic> _save = {};

  void saveCache(String key, dynamic value) {
    _save[key] = value;
  }

  dynamic loadCache(String key, [bool isAutoRemove = false]) {
    final value = _save[key];
    if (isAutoRemove) _save.remove(key);
    return value;
  }

  void removeCache(String key) {
    _save.remove(key);
  }

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    if (this.navigatorKey != navigatorKey) {
      // ignore: invalid_use_of_protected_member
      _currentState?.dispose();
    }
    this.navigatorKey = navigatorKey;
  }

  NavigatorState? get _currentState => navigatorKey?.currentState;

  @optionalTypeArgs
  Future pushNamed(String routeName, {dynamic argument, RouteTransition? transition}) async {
    if (routeName.startsWith("https://")) {
      launchUrlString(routeName, mode: LaunchMode.inAppWebView);
    } else {
      final future = _currentState?.pushNamed(routeName,
              arguments: AppNavigatorConfiguration(
                transition: transition,
                arguments: argument,
              )) ??
          Future.value(null);
      if (_currentState != null) {
        _firePauseEvent();
        final result = await future;
        _fireResumeEvent();
        return result;
      } else {
        return await future;
      }
    }
  }

  @optionalTypeArgs
  Future pushReplacementNamed(String routeName,
      {dynamic argument, RouteTransition? transition}) async {
    final future = await _currentState?.pushReplacementNamed(routeName,
            arguments: AppNavigatorConfiguration(
              transition: transition,
              arguments: argument,
            )) ??
        Future.value(null);
    if (_currentState != null) {
      _firePauseEvent();
      final result = future;
      _fireResumeEvent();
      return result;
    } else {
      return future;
    }
  }

  @optionalTypeArgs
  Future pushNamedAndRemoveAll(String routeName) {
    return pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  @optionalTypeArgs
  Future pushNamedAndRemoveUntil(String routeName, RoutePredicate predicate,
      {dynamic arguments, RouteTransition? transition}) async {
    final future = await _currentState?.pushNamedAndRemoveUntil(
          routeName,
          predicate,
          arguments: AppNavigatorConfiguration(
            transition: transition,
            arguments: arguments,
          ),
        ) ??
        Future.value(null);
    if (_currentState != null) {
      _firePauseEvent();
      final result = future;
      _fireResumeEvent();
      return result;
    } else {
      return future;
    }
  }

  void addOnNavChangedListener(AppNavigatorListenState callBack) {
    _onNavChangedListeners.add(callBack);
  }

  void removeOnNavChangedListener(AppNavigatorListenState callBack) {
    _onNavChangedListeners.remove(callBack);
  }

  Future<void> _firePauseEvent() async {
    final lock = Lock();
    await lock.synchronized(() async {
      for (var element in _onNavChangedListeners) {
        element.onPause();
        element.onPauseFromPush();
      }
    });
  }

  Future<void> _fireResumeEvent() async {
    final lock = Lock();
    await lock.synchronized(() async {
      for (var element in _onNavChangedListeners) {
        element.onResume();
        element.onResumeFromPop();
      }
    });
  }

  void pop<T extends Object?>([T? result]) {
    _currentState?.pop(result);
  }

  void popUntil(RoutePredicate predicate) {
    _currentState?.popUntil(predicate);
  }

  void popUntilBase() {
    _currentState?.popUntil((p) {
      return p.isFirst;
    });
  }

  void showDefaultDialog([AppGlobalDialogConfig? appConfig]) {
    globalError.add(appConfig ??
        const AppGlobalDialogConfig(
          title: "เกิดข้อผิดพลาด",
        ));
  }

  void popUntilIfNotFoundPushNamed(String routeName) {
    var isFound = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isFound = true;
        return true;
      }
      return false;
    });
    if (!isFound) {
      pushNamed(routeName);
    }
  }
}
