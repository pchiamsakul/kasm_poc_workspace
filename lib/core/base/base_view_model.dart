import 'package:flutter/widgets.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/helper/provider.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:rxdart/rxdart.dart';

class BaseViewModel extends Disposable {
  final AppNavigator appNavigator = getIt();
  AppNavigatorListenState? _listener;
  final CompositeSubscription disposeBag = CompositeSubscription();

  void addOnNavChangedListener(AppNavigatorListenState listener) {
    if (_listener != null) {
      appNavigator.removeOnNavChangedListener(_listener!);
      WidgetsBinding.instance.removeObserver(_listener!);
    }
    _listener = listener;
    appNavigator.addOnNavChangedListener(listener);
    WidgetsBinding.instance.addObserver(listener);
  }

  @override
  void dispose() {
    if (_listener != null) {
      appNavigator.removeOnNavChangedListener(_listener!);
      WidgetsBinding.instance.removeObserver(_listener!);
    }
    disposeBag.dispose();
  }
}
