import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/media.dart';
import '../repositories/media_repository.dart';

class GetMedia implements UseCase<List<Media>, NoParams> {
  final MediaRepository mediaRepository;
  GetMedia(this.mediaRepository);

  @override
  Future<Either<Failure, List<Media>>> call(NoParams params) async {
    return await mediaRepository.getMedia();
  }
}
