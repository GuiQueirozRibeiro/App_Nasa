// External packages
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;

// Core module imports
import 'package:core/src/enums/media_type.dart';
import 'package:core/src/errors/server_exception.dart';
import 'package:core/src/services/http/i_http.dart';
import 'package:core/src/services/media/data/models/media_model.dart';

abstract interface class MediaLocalDataSource {
  List<MediaModel> getMedia({required DateTime date});
  Future<void> uploadLocalMedia({
    required List<MediaModel> mediaList,
    bool isFromCreate = true,
  });
}

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  final Box box;
  final IHttp httpClient;

  MediaLocalDataSourceImpl(this.box, this.httpClient);

  @override
  List<MediaModel> getMedia({required DateTime date}) {
    final DateTime endDate = date.add(const Duration(days: 1));
    final DateTime startDate = endDate.subtract(const Duration(days: 8));
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

  Future<MediaModel> _saveLocalMediaFile(MediaModel media) async {
    final bool isVideo = media.mediaType == MediaType.video;
    final String filePath =
        isVideo ? media.url : await _downloadAndSaveMedia(media.url);

    media = media.copyWith(
      url: filePath,
      mediaType: isVideo ? MediaType.videoFile : MediaType.imageFile,
    );
    return media;
  }

  Future<String> _downloadAndSaveMedia(String url) async {
    final String savePath =
        '${Directory.systemTemp.path}/${path.basename(url)}';
    await httpClient.download(url, savePath);

    return savePath;
  }
}
