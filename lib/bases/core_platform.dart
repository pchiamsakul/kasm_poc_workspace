import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CorePlatform {
  CorePlatform._();

  static TargetPlatform? _targetPlatform;

  static void setPlatform(TargetPlatform targetPlatform) {
    _targetPlatform = targetPlatform;
  }

  static void refresh(BuildContext context) {
    setPlatform(Theme.of(context).platform);
  }

  static bool get isWeb => kIsWeb;

  static bool get isIos {
    if (_targetPlatform == null) {
      return Platform.isIOS;
    } else {
      return _targetPlatform == TargetPlatform.iOS;
    }
  }

  static bool get isAndroid {
    if (_targetPlatform == null) {
      return Platform.isAndroid;
    } else {
      return _targetPlatform == TargetPlatform.android;
    }
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
