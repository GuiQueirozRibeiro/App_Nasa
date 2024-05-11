import '../../../core/error/server_exception.dart';
import '../../../core/utils/http_dio.dart';
import '../models/media_model.dart';

abstract class MediaRemoteDataSource {
  Future<List<MediaModel>> getMedia();
  Future<List<MediaModel>> getMoreMedia({required DateTime date});
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final HttpDio httpDio;

  MediaRemoteDataSourceImpl(this.httpDio);

  @override
  Future<List<MediaModel>> getMedia() async {
    try {
      final List<dynamic> mediaList = await httpDio.fetchMedia();
      return _parseMediaList(mediaList);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MediaModel>> getMoreMedia({required DateTime date}) async {
    try {
      final List<dynamic> mediaList = await httpDio.fetchMedia(date: date);
      return _parseMediaList(mediaList);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  List<MediaModel> _parseMediaList(List<dynamic> mediaList) {
    return mediaList
        .map((media) => MediaModel.fromJson(media))
        .toList()
        .reversed
        .toList();
  }
}
