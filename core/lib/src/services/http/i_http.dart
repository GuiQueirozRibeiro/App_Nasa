// Core module imports
import 'package:core/src/services/http/http_response.dart';

abstract interface class IHttp {
  Future<HttpResponse<T>> get<T>({
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
}
