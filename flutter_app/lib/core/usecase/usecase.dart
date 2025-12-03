import 'package:dartz/dartz.dart';
import 'package:turbo_vets_assessment/core/errors/failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}