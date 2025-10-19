import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'hub_page.g.dart';

@HiveType(typeId: 1) // Unique typeId (0 was HistoryItem)
class HubPage extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String primaryLink;

  @HiveField(4)
  final String? imagePath; // Local path to the saved image

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  int scanCount;

  HubPage({
    required this.title,
    required this.description,
    required this.primaryLink,
    this.imagePath,
    required this.createdAt,
    this.scanCount = 0,
  }) {
    id = const Uuid().v4(); // Generate a unique ID on creation
  }
}
