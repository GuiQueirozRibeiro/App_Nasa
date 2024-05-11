import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/server_exception.dart';
import '../../../core/network/connection_checker.dart';
import '../../../core/utils/time_util.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_local_data_source.dart';
import '../datasources/media_remote_data_source.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;
  final MediaLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  MediaRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<Media>>> getMedia() async {
    try {
      if (!await connectionChecker.isConnected) {
        final localMedia = localDataSource.getMedia();
        final convertedMediaList =
            localMedia.map((model) => model.toMedia()).toList();
        return right(convertedMediaList);
      }
      final remoteMedia = await remoteDataSource.getMedia();
      localDataSource.uploadLocalMedia(mediaList: remoteMedia);
      final convertedMediaList =
          remoteMedia.map((model) => model.toMedia()).toList();
      return right(convertedMediaList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getMoreMedia({
    required List<Media> mediaList,
  }) async {
    try {
      final date = mediaList.last.date.subtract(const Duration(days: 1));
      if (!await connectionChecker.isConnected) {
        final newMediaModels = localDataSource.getMoreMedia(date: date);
        final convertedNewMediaList =
            newMediaModels.map((model) => model.toMedia()).toList();
        return right(convertedNewMediaList);
      }
      final newMediaModels = await remoteDataSource.getMoreMedia(date: date);
      localDataSource.uploadLocalMedia(
          mediaList: newMediaModels, isFromCreate: false);
      final convertedNewMediaList =
          newMediaModels.map((model) => model.toMedia()).toList();
      return right(convertedNewMediaList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> searchMedia({
    required List<Media> mediaList,
    required String query,
  }) async {
    try {
      Set<Media> uniqueMedia = {};
      RegExp regex = RegExp(r'[0-9/\\-]');
      bool containsDateChars = regex.hasMatch(query);

      if (containsDateChars) {
        uniqueMedia.addAll(_searchMediaByDate(mediaList, query));
      }
      String lowercaseQuery = query.toLowerCase();
      uniqueMedia.addAll(_searchMediaByTitle(mediaList, lowercaseQuery));

      List<Media> filteredMedia = uniqueMedia.toList();
      return right(filteredMedia);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  List<Media> _searchMediaByDate(List<Media> mediaList, String query) {
    return mediaList
        .where((media) => TimeUtil.containsDateString(media.date, query))
        .toList();
  }

  List<Media> _searchMediaByTitle(List<Media> mediaList, String query) {
    return mediaList
        .where((media) => media.title.toLowerCase().contains(query))
        .toList();
  }
}
