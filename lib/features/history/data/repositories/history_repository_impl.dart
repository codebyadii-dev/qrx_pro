import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:qrx_pro/core/services/database/database_service.dart';
import 'package:qrx_pro/core/services/database/hive_boxes.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';

abstract class IHistoryRepository {
  Future<void> saveHistoryItem(HistoryItem item);
  Future<List<HistoryItem>> getHistoryItems();
}

@LazySingleton(as: IHistoryRepository)
class HistoryRepositoryImpl implements IHistoryRepository {
  final DatabaseService _databaseService;
  late final Box<HistoryItem> _historyBox;

  HistoryRepositoryImpl(this._databaseService) {
    _historyBox = _databaseService.getBox<HistoryItem>(HiveBoxes.history);
  }

  @override
  Future<void> saveHistoryItem(HistoryItem item) async {
    // Hive's put() method is an upsert (update or insert).
    // We'll use add() to ensure a new entry every time.
    await _historyBox.add(item);
  }

  @override
  Future<List<HistoryItem>> getHistoryItems() async {
    // Hive boxes are like maps, so .values gives an iterable of all items.
    // We reverse it to show the newest items first.
    return _historyBox.values.toList().reversed.toList();
  }
}
