import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentType { dev, uat, prod }

class EnvironmentConfig {
  final EnvironmentType _type;

  static late final EnvironmentConfig instance;

  EnvironmentConfig._(this._type);

  static String? getValue(String key) {
    final value = dotenv.env[key];
    if (kDebugMode) {
      print('EnvironmentConfig: getValue $key=$value');
    }
    return value;
  }

  static EnvironmentType get type {
    return instance._type;
  }

  factory EnvironmentConfig(EnvironmentType type) {
    return EnvironmentConfig._(type);
  }

  static Future<EnvironmentConfig> build(EnvironmentType env) async {
    await dotenv.load(fileName: '${env.toString().split('.').last}.env');

    instance = EnvironmentConfig(env);
    return instance;
  }
}
