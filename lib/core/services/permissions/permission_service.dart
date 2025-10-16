import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionService {
  /// Checks if camera permission is granted.
  Future<bool> isCameraGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Requests camera permission from the user.
  /// Returns `true` if granted, `false` otherwise.
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Checks if storage permission is granted.
  /// Note: On newer Android versions (API 33+), this permission is not needed
  /// for saving to standard gallery folders. On iOS, it's required.
  Future<bool> isStorageGranted() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  /// Requests storage permission from the user.
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Opens the app settings so the user can manually change permissions.
  /// This is useful when a permission is permanently denied.
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
