// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/custom_log_interceptor.dart';

export 'package:dio/dio.dart';

@singleton
class DioClient {
  static Dio? _dio;

  DioClient();

  Dio get client {
    if (_dio != null) {
      return _dio!;
    } else {
      _dio = _initClient();
      return _dio!;
    }
  }

  Dio _initClient() => Dio()
    ..interceptors.addAll([
      /// take more buffer
      CustomLogInterceptor(logPrint: _log, requestBody: true, responseBody: true),
    ]);

  /// take more buffer
  void _log(Object object) {
    final logLine = object is String ? object : jsonEncode(object).replaceAll('\\"', '"');
    if (logLine.length > 5000) {
      print(logLine.substring(0, 5000));
    } else {
      print(logLine);
    }
  }
}
