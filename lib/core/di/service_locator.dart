import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This file is auto-generated after running build_runner
import 'service_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default name of generated method
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureDependencies() async => getIt.init();
