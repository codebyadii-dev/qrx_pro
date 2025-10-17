// lib/core/services/database/database_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrx_pro/core/services/database/hive_boxes.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';

@lazySingleton
@preResolve
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

    // *** ADD THIS LINE TO REGISTER THE ADAPTER ***
    Hive.registerAdapter(HistoryItemAdapter());

    // Open Hive boxes
    await Hive.openBox<HistoryItem>(HiveBoxes.history); // Specify the type
    await Hive.openBox(HiveBoxes.settings);
  }

  // Update getBox to be type-safe for HistoryItem
  Box<T> getBox<T>(String name) => Hive.box<T>(name);

  Future<void> close() async => Hive.close();
}
