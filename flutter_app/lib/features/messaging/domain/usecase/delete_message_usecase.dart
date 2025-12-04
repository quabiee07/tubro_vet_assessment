import 'package:dartz/dartz.dart';
import 'package:turbo_vets_assessment/core/domain/errors/failure.dart';
import 'package:turbo_vets_assessment/core/domain/usecase/usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/repository/messaging_repository.dart';
class DeleteMessage implements UseCase<void, DeleteMessageParams> {
  final MessageRepository repository;

  DeleteMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMessageParams params) async {
    return await repository.deleteMessage(params.id);
  }
}

class DeleteMessageParams {
  final int id;

  DeleteMessageParams({required this.id});
}