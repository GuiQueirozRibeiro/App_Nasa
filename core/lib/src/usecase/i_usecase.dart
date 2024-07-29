// External packages
import 'package:fpdart/fpdart.dart';

// Core module imports
import 'package:core/src/errors/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
