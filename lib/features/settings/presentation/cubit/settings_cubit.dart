import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qrx_pro/core/config/app_theme_mode.dart';
import 'package:qrx_pro/core/services/settings/settings_service.dart';
import 'package:qrx_pro/features/history/data/repositories/history_repository_impl.dart';

// A simple state object
class SettingsState {
  final AppThemeMode themeMode;
  final bool isOfflineMode;
  SettingsState({required this.themeMode, required this.isOfflineMode});
}

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;
  final IHistoryRepository _historyRepository;

  SettingsCubit(this._settingsService, this._historyRepository)
    : super(
        SettingsState(
          themeMode: _settingsService.getThemeMode(),
          isOfflineMode: _settingsService.isOfflineModeEnabled(),
        ),
      );

  void changeTheme(AppThemeMode themeMode) {
    _settingsService.setThemeMode(themeMode);
    emit(
      SettingsState(themeMode: themeMode, isOfflineMode: state.isOfflineMode),
    );
  }

  void toggleOfflineMode(bool isEnabled) {
    _settingsService.setOfflineMode(isEnabled);
    emit(SettingsState(themeMode: state.themeMode, isOfflineMode: isEnabled));
  }

  Future<void> clearHistory() async {
    await _historyRepository.clearHistory();
  }
}
