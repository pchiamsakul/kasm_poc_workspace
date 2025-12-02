// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/environment_config.dart';

class Init {
  Init._();

  static final instance = Init._();

  bool _setupComplete = false;

  bool get isSetupComplete => _setupComplete;

  Future initialize(env) async {
    if (!_setupComplete) {
      await EnvironmentConfig.build(env);
      WidgetsFlutterBinding.ensureInitialized();
      await configureDependencies();
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      _setupComplete = true;
    }
  }
}
