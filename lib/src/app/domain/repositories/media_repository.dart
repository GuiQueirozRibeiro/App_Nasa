import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';
import '../entities/media.dart';

abstract interface class MediaRepository {
  Future<Either<Failure, List<Media>>> getMedia();
  Future<Either<Failure, List<Media>>> getMoreMedia({
    required List<Media> mediaList,
  });
  Future<Either<Failure, List<Media>>> searchMedia({
    required List<Media> mediaList,
    required String query,
  });
}
