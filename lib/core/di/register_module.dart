import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:qrx_pro/core/navigation/app_router.dart';

@module
abstract class RegisterModule {
  // We register GoRouter as a lazy singleton, so it's created only when first requested.
  @lazySingleton
  GoRouter get router => AppRouter.router;
}
