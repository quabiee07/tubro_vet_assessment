
import 'package:dartz/dartz.dart';
import 'package:turbo_vets_assessment/core/errors/failure.dart';
import 'package:turbo_vets_assessment/features/messaging/data/data_source/message_local_data_source.dart';
import 'package:turbo_vets_assessment/features/messaging/data/models/message_model.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/repository/messaging_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageLocalDataSource localDataSource;

  MessageRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Message>>> getMessages() async {
    try {
      final messages = await localDataSource.getMessages();
      return Right(messages);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      await localDataSource.insertMessage(messageModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(int id) async {
    try {
      await localDataSource.deleteMessage(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}