// External packages
import 'package:fpdart/fpdart.dart';

// Core module imports
import 'package:core/src/errors/failures.dart';
import 'package:core/src/services/media/domain/entities/media.dart';
import 'package:core/src/services/media/domain/repository/media_repository.dart';
import 'package:core/src/usecase/i_usecase.dart';

class GetMoreMedia implements UseCase<List<Media>, GetMoreMediaParams> {
  final MediaRepository mediaRepository;

  const GetMoreMedia(this.mediaRepository);

  @override
  Future<Either<Failure, List<Media>>> call(GetMoreMediaParams params) async {
    return await mediaRepository.getMedia(date: params.date);
  }
}

class GetMoreMediaParams {
  final DateTime date;

  const GetMoreMediaParams({required this.date});
}
