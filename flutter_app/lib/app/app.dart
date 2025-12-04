import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo_vets_assessment/core/di/injection_container.dart';
import 'package:turbo_vets_assessment/features/home/presentation/screen/home.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_bloc.dart';

class TurboVetsApp extends StatelessWidget {
  const TurboVetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MessageBloc>(),
      child: MaterialApp(
        title: 'Turbo Vets Assessment',
        debugShowCheckedModeBanner: false,
        home: const Home(),
      ),
    );
  }
}
