// lib/main.dart

import 'package:flutter/material.dart';
import 'package:qrx_pro/app/view/app.dart';
import 'package:qrx_pro/core/di/service_locator.dart';

// The function must be async to use 'await'.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // We MUST await the configuration since our database init is async.
  await configureDependencies();

  runApp(const App());
}
