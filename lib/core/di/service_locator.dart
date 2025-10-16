import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This is the generated file. It will show an error until you run the build command.
import 'service_locator.config.dart';

// Create a global instance of GetIt
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => getIt.init();
