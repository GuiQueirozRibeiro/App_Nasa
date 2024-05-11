import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';

import '../entities/media.dart';
import '../repositories/media_repository.dart';

class GetMoreMedia implements UseCase<List<Media>, GetMoreMediaParams> {
  final MediaRepository mediaRepository;
  GetMoreMedia(this.mediaRepository);

  @override
  Future<Either<Failure, List<Media>>> call(GetMoreMediaParams params) async {
    return await mediaRepository.getMoreMedia(mediaList: params.mediaList);
  }
}

class GetMoreMediaParams {
  final List<Media> mediaList;
  GetMoreMediaParams({required this.mediaList});
}
