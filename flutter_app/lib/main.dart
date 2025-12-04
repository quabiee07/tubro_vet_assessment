import 'package:flutter/material.dart';
import 'package:turbo_vets_assessment/app/app.dart';
import 'package:turbo_vets_assessment/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const TurboVetsApp());
}

