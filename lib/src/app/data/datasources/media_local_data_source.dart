import 'package:hive/hive.dart';
import '../../../core/enums/media_type.dart';
import '../../../core/error/server_exception.dart';
import '../../../core/utils/http_dio.dart';
import '../models/media_model.dart';

abstract class MediaLocalDataSource {
  List<MediaModel> getMedia();
  List<MediaModel> getMoreMedia({required DateTime date});
  Future<void> uploadLocalMedia({
    required List<MediaModel> mediaList,
    bool isFromCreate = true,
  });
}

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  final Box box;
  final HttpDio httpDio;

  MediaLocalDataSourceImpl(this.box, this.httpDio);

  @override
  List<MediaModel> getMedia() {
    final DateTime endDate = DateTime.now().add(const Duration(days: 1));
    final DateTime startDate = endDate.subtract(const Duration(days: 8));
    return _fetchMedia(startDate, endDate);
  }

  @override
  List<MediaModel> getMoreMedia({required DateTime date}) {
    final DateTime endDate = date.add(const Duration(days: 1));
    final DateTime startDate = endDate.subtract(const Duration(days: 8));
    return _fetchMedia(startDate, endDate);
  }

  @override
  Future<void> uploadLocalMedia({
    required List<MediaModel> mediaList,
    bool isFromCreate = true,
  }) async {
    if (isFromCreate) box.clear();
    final List<MediaModel> copiedList = List.from(mediaList);
    for (final media in copiedList) {
      try {
        final MediaModel updatedMedia = await _saveLocalMediaFile(media);
        box.add(updatedMedia.toJson());
        mediaList.remove(media);
      } catch (e) {
        throw ServerException(e.toString());
      }
    }
  }

  List<MediaModel> _fetchMedia(DateTime startDate, DateTime endDate) {
    final List<MediaModel> mediaList = [];
    box.toMap().forEach((key, value) {
      final Map<dynamic, dynamic> mediaData = value as Map<dynamic, dynamic>;
      final media = MediaModel.fromJson(mediaData.cast<String, dynamic>());
      if (media.date.isAfter(startDate) && media.date.isBefore(endDate)) {
        mediaList.add(media);
      }
    });
    mediaList.sort((a, b) => b.date.compareTo(a.date));
    return mediaList;
  }

  Future<MediaModel> _saveLocalMediaFile(MediaModel media) async {
    final bool isVideo = media.mediaType == MediaType.video;
    final String filePath =
        isVideo ? media.url : await httpDio.downloadFile(media.url);
    media = media.copyWith(
      url: filePath,
      mediaType: isVideo ? MediaType.videoFile : MediaType.imageFile,
    );
    return media;
  }
}
