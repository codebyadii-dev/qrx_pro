import 'package:injectable/injectable.dart';
import 'package:qrx_pro/core/services/settings/settings_service.dart'; // Import SettingsService
import 'package:qrx_pro/features/scanner/domain/entities/url_metadata.dart';

@lazySingleton
class AiHelperService {
  // Inject the SettingsService
  final SettingsService _settingsService;
  AiHelperService(this._settingsService);

  Future<UrlMetadata> fetchUrlMetadata(String url) async {
    // --- THIS IS THE KEY LOGIC ---
    // If offline mode is enabled, immediately return generic data.
    if (_settingsService.isOfflineModeEnabled()) {
      return UrlMetadata(
        title: 'Offline Mode Enabled',
        description: 'URL analysis is disabled for privacy.',
        faviconUrl: '',
        safetyScore: 0.85, // Default safe score
      );
    }

    // --- The rest of the method is the same as before ---
    await Future.delayed(const Duration(milliseconds: 1500));

    if (url.contains('google.com')) {
      return UrlMetadata(
        title: 'Google',
        description: 'A multinational technology company...',
        faviconUrl: 'https://www.google.com/favicon.ico',
        safetyScore: 0.98,
      );
    } else if (url.contains('flutter.dev')) {
      return UrlMetadata(
        title: 'Flutter.dev',
        description: 'The official documentation and resource hub...',
        faviconUrl: 'https://flutter.dev/favicon.ico',
        safetyScore: 0.99,
      );
    } else {
      return UrlMetadata(
        title: 'Website Link',
        description: 'This link appears to be safe...',
        faviconUrl: '',
        safetyScore: 0.85,
      );
    }
  }
}
