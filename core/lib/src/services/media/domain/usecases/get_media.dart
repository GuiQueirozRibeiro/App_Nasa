// External packages
import 'package:fpdart/fpdart.dart';

// Core module imports
import 'package:core/src/errors/failures.dart';
import 'package:core/src/services/media/domain/entities/media.dart';
import 'package:core/src/services/media/domain/repository/media_repository.dart';
import 'package:core/src/usecase/i_usecase.dart';
import 'package:core/src/usecase/no_params.dart';

class GetMedia implements UseCase<List<Media>, NoParams> {
  final MediaRepository mediaRepository;

  const GetMedia(this.mediaRepository);

  @override
  Future<Either<Failure, List<Media>>> call(NoParams params) async {
    final date = DateTime.now();
    return await mediaRepository.getMedia(date: date);
  }
}
