import 'package:dartz/dartz.dart';
import 'package:turbo_vets_assessment/core/errors/failure.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<Message>>> getMessages();
  Future<Either<Failure, void>> sendMessage(Message message);
  Future<Either<Failure, void>> deleteMessage(int id);
}