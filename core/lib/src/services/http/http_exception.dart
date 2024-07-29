// External packages
import 'package:dio/dio.dart';

class HttpExceptionCustom implements Exception {
  final RequestOptions requestOptions;
  final Response? response;
  final DioExceptionType type;
  final Object? error;
  final StackTrace stackTrace;
  final String? message;
  final String? msg;
  HttpExceptionCustom({
    required this.requestOptions,
    required this.type,
    required this.stackTrace,
    this.response,
    this.error,
    this.message,
    this.msg,
  });
  HttpExceptionCustom copyWith({
    RequestOptions? requestOptions,
    Response? response,
    DioExceptionType? type,
    Object? error,
    StackTrace? stackTrace,
    String? message,
  }) {
    return HttpExceptionCustom(
      requestOptions: requestOptions ?? this.requestOptions,
      response: response ?? this.response,
      type: type ?? this.type,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    String result = msg ?? '$message';
    if (error != null) result += '\nError: $error';

    return result;
  }
}
