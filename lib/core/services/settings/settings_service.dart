import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:qrx_pro/core/config/app_theme_mode.dart';
import 'package:qrx_pro/core/services/database/database_service.dart';
import 'package:qrx_pro/core/services/database/hive_boxes.dart';

@lazySingleton
class SettingsService {
  late final Box _settingsBox;

  // Hive keys for settings
  static const String _offlineModeKey = 'offline_mode_enabled';
  static const String _themeModeKey = 'theme_mode';

  SettingsService(DatabaseService databaseService) {
    _settingsBox = databaseService.getBox(HiveBoxes.settings);
  }

  // --- Offline Mode ---
  bool isOfflineModeEnabled() {
    // Return the saved value, defaulting to `false` if it's not set.
    return _settingsBox.get(_offlineModeKey, defaultValue: false) as bool;
  }

  Future<void> setOfflineMode(bool isEnabled) async {
    await _settingsBox.put(_offlineModeKey, isEnabled);
  }

  // --- Theme Mode ---
  AppThemeMode getThemeMode() {
    final themeName =
        _settingsBox.get(_themeModeKey, defaultValue: AppThemeMode.system.name)
            as String;
    return AppThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await _settingsBox.put(_themeModeKey, themeMode.name);
  }
}
