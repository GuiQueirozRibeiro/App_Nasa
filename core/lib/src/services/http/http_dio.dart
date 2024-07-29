// Dart native imports
import 'dart:convert';

// External packages
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Core module imports
import 'package:core/src/log/log.dart';
import 'package:core/src/secrets/core_secrets.dart';
import 'package:core/src/services/http/http_exception.dart';
import 'package:core/src/services/http/http_response.dart';
import 'package:core/src/services/http/i_http.dart';

class HttpDio implements IHttp {
  late final Dio _dio;
  final bool autoToast;
  final log = Log(printer: PrettyPrinter());

  HttpDio({BaseOptions? baseOptions, this.autoToast = false}) {
    baseOptions != null ? _dio = Dio(baseOptions) : _dio = Dio(_defaultOptions);
  }

  final _defaultOptions = BaseOptions(
    baseUrl: 'https://api.nasa.gov/planetary/apod?api_key=${Secrets.apiKey}',
    headers: {"Content-Type": "application/json"},
  );

  @override
  IHttp auth() {
    _defaultOptions.extra["auth_required"] = true;
    return this;
  }

  @override
  IHttp unauth() {
    _defaultOptions.extra["auth_required"] = false;
    return this;
  }

  @override
  Future<HttpResponse<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? query,
      Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "DELETE",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers,
          data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "DELETE",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<HttpResponse<T>> get<T>(
      {Map<String, dynamic>? query,
      Map<String, dynamic>? headers,
      void Function(int, int)? onReceiveProgress}) async {
    try {
      _logInfo('', "GET",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers);
      final DateTime start = DateTime.now();
      final response = await _dio.get(
        '',
        queryParameters: query,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );
      final DateTime end = DateTime.now();
      _logResponse('', "GET",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<HttpResponse<T>> download<T>(
    String path,
    String savePath, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    void Function(int, int)? onReceiveProgress,
    void Function(double percent)? onReceiveProgressPercent,
  }) async {
    try {
      _logInfo(path, "DOWNLOAD",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers);
      final DateTime start = DateTime.now();
      final response = await _dio.download(
        path,
        savePath,
        onReceiveProgress: (count, total) {
          onReceiveProgress?.call(count, total);
          final double result = (total > 0) ? count / total : 0.1;
          onReceiveProgressPercent?.call(result);
        },
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "DOWNLOAD",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<HttpResponse<T>> patch<T>(String path,
      {data,
      Map<String, dynamic>? query,
      Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "PATCH",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers,
          data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "PATCH",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      _logInfo(path, "POST",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers,
          data: data is Map ? jsonEncode(data) : '');
      final DateTime start = DateTime.now();
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "POST",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<HttpResponse<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? query,
      Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "PUT",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers,
          data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "PUT",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<HttpResponse<T>> request<T>(String path,
      {data,
      Map<String, dynamic>? query,
      Map<String, dynamic>? headers}) async {
    try {
      _logInfo(path, "REQUEST",
          queryParamters: query,
          headers: headers,
          baseOptions: _dio.options.headers,
          data: data);
      final DateTime start = DateTime.now();
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      final DateTime end = DateTime.now();
      _logResponse(path, "REQUEST",
          response: response,
          time: end.difference(start).inMilliseconds.toString());
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      return _trowRestClientException(e);
    }
  }

  Future<HttpResponse<T>> _dioResponseConverter<T>(
      Response<dynamic> response) async {
    return HttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  String getErrorMessage(DioException dioError) {
    if (dioError.response?.data['error_description'] != null) {
      return dioError.response?.data['error_description'];
    }
    if (dioError.response?.data['error'] != null) {
      return dioError.response?.data['error'];
    }
    if (dioError.response?.data['message'] != null) {
      return dioError.response?.data['message'];
    }
    if (dioError.response?.data['message'] != null) {
      return dioError.response?.data['message'];
    }

    if (dioError.response?.data['msg'] != null) {
      return dioError.response?.data['msg'];
    }

    return dioError.toString();
  }

  Never _trowRestClientException(DioException dioError) {
    final exception = HttpExceptionCustom(
      error: dioError.error,
      message: getErrorMessage(dioError),
      response: dioError.response,
      requestOptions: dioError.requestOptions,
      stackTrace: dioError.stackTrace,
      type: dioError.type,
      msg: getErrorMessage(dioError),
    );
    _logError(
        error: exception.error.toString(),
        stackTrace: exception.stackTrace,
        message: exception.msg ?? exception.message,
        statusCode: exception.response?.statusCode.toString());
    throw Exception(exception.message ?? exception);
  }

  void _logInfo(String path, String methodo,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? baseOptions,
      Map<String, dynamic>? queryParamters,
      dynamic data}) {
    log.i(
        'METHOD: $methodo \nPATH: ${_dio.options.baseUrl}$path \nQUERYPARAMTERS: $queryParamters \nHEADERS: $headers \nBASEOPTIONS: $baseOptions \nDATA: ${data is Uint8List ? 'bytes' : data}');
  }

  void _logError(
      {String? error,
      String? message,
      String? statusCode,
      StackTrace? stackTrace}) {
    log
      ..f('ERROR: $error \nMESSAGE: $message \nSTATUSCODE: $statusCode')
      ..w('STACKTRACE: $stackTrace');
  }

  void _logResponse(String path, String methodo,
      {Response? response, String? time}) {
    if (response?.statusCode == 200) {
      log.d(
          '[RESPONSE]: ${response?.statusCode}\nMETHOD: $methodo \nPATH: ${_dio.options.baseUrl}$path \nTIME: 🕑$time ms \nRESPONSE: ${response?.data}');
    } else {
      log.f(
          '[RESPONSE]: ${response?.statusCode}\nMETHOD: $methodo \nPATH: ${_dio.options.baseUrl}$path \nTIME: 🕑$time ms \nRESPONSE: ${response?.data}');
    }
  }
}
