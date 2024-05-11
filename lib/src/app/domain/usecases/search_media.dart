import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';

import '../entities/media.dart';
import '../repositories/media_repository.dart';

class SearchMedia implements UseCase<List<Media>, SearchMediaParams> {
  final MediaRepository mediaRepository;
  SearchMedia(this.mediaRepository);

  @override
  Future<Either<Failure, List<Media>>> call(SearchMediaParams params) async {
    return mediaRepository.searchMedia(
      mediaList: params.mediaList,
      query: params.query,
    );
  }
}

class SearchMediaParams {
  final List<Media> mediaList;
  final String query;

  SearchMediaParams({required this.query, required this.mediaList});
}
