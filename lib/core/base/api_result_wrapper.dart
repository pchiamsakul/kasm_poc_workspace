// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'api_result_wrapper.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResultWrapper<T> {
  final int code;
  final String? message;
  final String? errorMessage;
  final T? data;

  ApiResultWrapper(
    this.code,
    this.message,
    this.errorMessage,
    this.data,
  );

  factory ApiResultWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResultWrapperFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResultWrapperToJson(this, toJsonT);
}
