// External packages
import 'package:fpdart/fpdart.dart';

// Core module imports
import 'package:core/src/errors/failures.dart';
import 'package:core/src/services/media/domain/entities/media.dart';

abstract interface class MediaRepository {
  Future<Either<Failure, List<Media>>> getMedia({required DateTime date});
  Future<Either<Failure, List<Media>>> searchMedia({
    required List<Media> mediaList,
    required String query,
  });
}
