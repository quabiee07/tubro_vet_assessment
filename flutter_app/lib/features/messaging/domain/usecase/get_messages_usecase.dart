import 'package:dartz/dartz.dart';
import 'package:turbo_vets_assessment/core/errors/failure.dart';
import 'package:turbo_vets_assessment/core/usecase/usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/repository/messaging_repository.dart';

class GetMessages implements UseCase<List<Message>, NoParams> {
  final MessageRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(NoParams params) async {
    return await repository.getMessages();
  }
}