import 'package:flutter/foundation.dart';
import 'package:kasm_poc_workspace/utils/environment_util.dart';
import 'package:kasm_poc_workspace/utils/logger_mixin.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum AppEnvironment { develop, staging, production }

class AppConstants with BuiltInLogger {
  final AppEnvironment envName;
  final String appVersion;
  final int buildNumber;

  AppConstants({required this.envName, required this.appVersion, required this.buildNumber});

  static Future<AppConstants> initialized(PackageInfo packageInfo) async {
    try {
      final env = EnvironmentWrapper.getEnv();

      return AppConstants(
        envName: env,
        appVersion: packageInfo.version,
        buildNumber: int.tryParse(packageInfo.buildNumber) ?? 0,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing AppConstants: $e');
      }
      rethrow;
    }
  }
}
