// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:turbo_vets_assessment/features/messaging/data/data_source/message_local_data_source.dart';
import 'package:turbo_vets_assessment/features/messaging/data/repository/message_repository_impl.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/repository/messaging_repository.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/usecase/delete_message_usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/usecase/get_messages_usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/usecase/send_message_usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () =>
        MessageBloc(getMessages: sl(), sendMessage: sl(), deleteMessage: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => DeleteMessage(sl()));

  // Repository
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MessageLocalDataSource>(
    () => MessageLocalDataSourceImpl(),
  );
}
