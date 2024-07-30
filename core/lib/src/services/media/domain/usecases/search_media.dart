// External packages
import 'package:fpdart/fpdart.dart';

// Core module imports
import 'package:core/src/errors/failures.dart';
import 'package:core/src/services/media/domain/entities/media.dart';
import 'package:core/src/services/media/domain/repository/media_repository.dart';
import 'package:core/src/usecase/i_usecase.dart';

class SearchMedia implements UseCase<List<Media>, SearchMediaParams> {
  final MediaRepository mediaRepository;

  const SearchMedia(this.mediaRepository);

  @override
  Future<Either<Failure, List<Media>>> call(SearchMediaParams params) async {
    return mediaRepository.searchMedia(
      mediaList: params.mediaList,
      query: params.query,
    );
  }
}

class SearchMediaParams {
  final String query;
  final List<Media> mediaList;

  const SearchMediaParams({required this.query, required this.mediaList});
}
