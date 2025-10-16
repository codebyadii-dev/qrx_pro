import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrx_pro/core/services/database/hive_boxes.dart';

@lazySingleton
@preResolve // ensures this service is initialized before app starts
class DatabaseService {
  @factoryMethod
  static Future<DatabaseService> create() async {
    final instance = DatabaseService();
    await instance.init();
    return instance;
  }

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Open Hive boxes
    await Hive.openBox(HiveBoxes.history);
    await Hive.openBox(HiveBoxes.settings);
  }

  Box<T> getBox<T>(String name) => Hive.box<T>(name);

  Future<void> close() async => Hive.close();
}
