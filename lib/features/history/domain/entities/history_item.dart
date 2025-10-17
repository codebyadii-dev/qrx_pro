import 'package:hive/hive.dart';

part 'history_item.g.dart';

@HiveType(typeId: 0) // typeId must be unique for each HiveObject
class HistoryItem extends HiveObject {
  @HiveField(0)
  final String rawValue;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String type; // We'll store the type as a string for now

  HistoryItem({
    required this.rawValue,
    required this.timestamp,
    required this.type,
  });
}
