// lib/main.dart
import 'package:flutter/material.dart';
import 'package:qrx_pro/app/view/app.dart';
import 'package:qrx_pro/core/di/service_locator.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `runApp()` can be
  // called before anything else.
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // In future , we will initialize services here:
  // - Dependency Injection (get_it)
  // - Local Database (Hive)
  // - Environment Configuration

  runApp(const App());
}
