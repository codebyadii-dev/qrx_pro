import 'dart:io';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrx_pro/core/services/database/database_service.dart';
import 'package:qrx_pro/core/services/database/hive_boxes.dart';
import 'package:qrx_pro/features/hub/domain/entities/hub_page.dart';
import 'package:path/path.dart' as p;

abstract class IHubRepository {
  Future<HubPage> saveHubPage({
    required String title,
    required String description,
    required String primaryLink,
    File? imageFile,
  });
}

@LazySingleton(as: IHubRepository)
class HubRepositoryImpl implements IHubRepository {
  final DatabaseService _databaseService;
  late final Box<HubPage> _hubBox;

  HubRepositoryImpl(this._databaseService) {
    _hubBox = _databaseService.getBox<HubPage>(HiveBoxes.hubPages);
  }

  @override
  Future<HubPage> saveHubPage({
    required String title,
    required String description,
    required String primaryLink,
    File? imageFile,
  }) async {
    String? localImagePath;
    if (imageFile != null) {
      // Save the image to the app's local storage
      final appDocsDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDocsDir.path}/$fileName');
      localImagePath = savedImage.path;
    }

    final newHubPage = HubPage(
      title: title,
      description: description,
      primaryLink: primaryLink,
      imagePath: localImagePath,
      createdAt: DateTime.now(),
    );

    await _hubBox.put(newHubPage.id, newHubPage);
    return newHubPage;
  }
}
