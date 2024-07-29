// Core module imports
import 'package:core/src/services/http/http_response.dart';

abstract interface class IHttp {
  IHttp auth();

  IHttp unauth();

  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<HttpResponse<T>> get<T>({
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<HttpResponse<T>> download<T>(
    String path,
    String savePath, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    void Function(int, int)? onReceiveProgress,
    void Function(double percent)? onReceiveProgressPercent,
  });

  Future<HttpResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<HttpResponse<T>> request<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });
}
