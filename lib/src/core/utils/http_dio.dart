import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import '../secrets/app_secrets.dart';
import 'time_util.dart';

class HttpDio {
  final Directory mediaDirectory;
  HttpDio(this.mediaDirectory);

  final Dio _dio = Dio();
  final String baseUrl =
      'https://api.nasa.gov/planetary/apod?api_key=${AppSecrets.apiKey}';

  Future<List<dynamic>> fetchMedia({DateTime? date}) async {
    final String startDate = '&start_date=${TimeUtil.getStartDate(date: date)}';
    final String endDate = '&end_date=${TimeUtil.getEndDate(date: date)}';

    final response = await _dio.get('$baseUrl$startDate$endDate');
    return response.data;
  }

  Future<String> downloadFile(String url) async {
    final String filePath = '${mediaDirectory.path}/${path.basename(url)}';
    await _dio.download(url, filePath);
    return filePath;
  }
}
