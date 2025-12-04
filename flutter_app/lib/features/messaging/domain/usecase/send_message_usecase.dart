import 'package:dartz/dartz.dart';
import 'package:turbo_vets_assessment/core/domain/errors/failure.dart';
import 'package:turbo_vets_assessment/core/domain/usecase/usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/repository/messaging_repository.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final MessageRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.message);
  }
}

class SendMessageParams {
  final Message message;

  SendMessageParams({required this.message});
}