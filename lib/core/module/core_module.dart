import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/environment_config.dart';

@module
abstract class CoreModule {
  /// Provides a separate Dio instance for token refresh
  /// This prevents infinite loops in the auth interceptor
  @Named('refreshDio')
  @singleton
  Dio get refreshDio => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// Provides base URL from environment config
  @Named('baseUrl')
  String get baseUrl => EnvironmentConfig.getValue('API_BASE_URL') ?? 'https://api.example.com';
}
