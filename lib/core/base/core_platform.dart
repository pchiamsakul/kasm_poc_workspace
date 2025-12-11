import 'package:flutter/material.dart';

class CorePlatform {
  CorePlatform._();

  static TargetPlatform? _targetPlatform;

  static void refresh(BuildContext context) {
    setPlatform(Theme.of(context).platform);
  }

  static void setPlatform(TargetPlatform targetPlatform) {
    _targetPlatform = targetPlatform;
  }

  static bool get isIos {
    assert(_targetPlatform != null);
    return _targetPlatform == TargetPlatform.iOS;
  }

  static bool get isAndroid {
    assert(_targetPlatform != null);
    return _targetPlatform == TargetPlatform.android;
  }

  static T switchPlatform<T>({required T iOS, required T android}) {
    assert(_targetPlatform != null);
    if (isIos) {
      return iOS;
    }
    return android;
  }

  static bool isUnitTest = false;
  static bool isIntegrationTest = false;

  static bool isIntegrationTestLogEnabled = false;
}
