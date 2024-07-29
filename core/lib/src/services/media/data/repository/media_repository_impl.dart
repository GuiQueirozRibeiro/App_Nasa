// External packages
import 'package:fpdart/fpdart.dart';

// Core module imports
import 'package:core/src/errors/failures.dart';
import 'package:core/src/errors/server_exception.dart';
import 'package:core/src/network/connection_checker.dart';
import 'package:core/src/services/media/data/datasources/media_local_data_source.dart';
import 'package:core/src/services/media/data/datasources/media_remote_data_source.dart';
import 'package:core/src/services/media/domain/entities/media.dart';
import 'package:core/src/services/media/domain/repository/media_repository.dart';
import 'package:core/src/utils/utils.dart';

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
  Future<Either<Failure, List<Media>>> getMedia({
    required DateTime date,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        final localMedia = localDataSource.getMedia(date: date);
        final mediaList = localMedia.map((model) => model.toMedia()).toList();
        return right(mediaList);
      }
      final startDate = TimeUtil.getStartDate(date: date);
      final endDate = TimeUtil.getEndDate(date: date);

      final remoteMedia = await remoteDataSource.getMedia(startDate, endDate);
      final mediaList = remoteMedia.map((model) => model.toMedia()).toList();
      localDataSource.uploadLocalMedia(mediaList: remoteMedia);

      return right(mediaList);
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
