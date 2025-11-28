import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:kasm_poc_workspace/constants/app_constants.dart';
import 'package:kasm_poc_workspace/di/configure_dependencies.dart';
import 'package:kasm_poc_workspace/utils/custom_log_tree.dart';
import 'package:kasm_poc_workspace/utils/environment_util.dart';
import 'package:kasm_poc_workspace/utils/logger_mixin.dart';

class Init with BuiltInLogger {
  Init._();

  static final instance = Init._();

  bool _setupComplete = false;

  bool get setupComplete => _setupComplete;

  Future<void> initialize({AppEnvironment? appEnvironment}) async {
    if (!_setupComplete) {
      WidgetsFlutterBinding.ensureInitialized();

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
      );

      final env = appEnvironment ?? EnvironmentWrapper.getEnv();

      await Future.wait([EnvironmentWrapper.loadEnvironmentVariables(env)]);

      await configureDependencies();

      if (kDebugMode) {
        _initFimber();
      }

      _setupComplete = true;
    }
  }

  void _initFimber() {
    Fimber.v('running in debug mode');
    Fimber.plantTree(CustomLogTree());
    Fimber.d('Test Message');
    Fimber.d('------------');
    Fimber.v('VERBOSE');
    Fimber.i('INFO');
    Fimber.d('DEBUG');
    Fimber.w('WARN');
    Fimber.e('ERROR');
    Fimber.d(' ');
  }
}
