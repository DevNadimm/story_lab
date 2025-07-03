import 'package:fpdart/fpdart.dart';
import 'package:story_lab/core/error/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
