// Core module imports
import 'package:core/src/errors/server_exception.dart';
import 'package:core/src/services/http/i_http.dart';
import 'package:core/src/services/media/data/models/media_model.dart';

abstract interface class MediaRemoteDataSource {
  Future<List<MediaModel>> getMedia(String startDate, String endDate);
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final IHttp httpClient;
  MediaRemoteDataSourceImpl(this.httpClient);

  @override
  Future<List<MediaModel>> getMedia(String startDate, String endDate) async {
    try {
      final query = <String, dynamic>{
        'start_date': startDate,
        'end_date': endDate,
      };
      final response = await httpClient.get(query: query);
      final List<dynamic> mediaList = response.data;
      return mediaList
          .map((media) => MediaModel.fromJson(media))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
