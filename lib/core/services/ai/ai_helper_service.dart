import 'package:injectable/injectable.dart';
import 'package:qrx_pro/features/scanner/domain/entities/url_metadata.dart';

@lazySingleton
class AiHelperService {
  /// Simulates fetching metadata for a given URL.
  /// In a real app, this would make an API call.
  Future<UrlMetadata> fetchUrlMetadata(String url) async {
    // Simulate a network delay of 1.5 seconds.
    await Future.delayed(const Duration(milliseconds: 1500));

    // Return mock data based on the URL for demonstration.
    if (url.contains('google.com')) {
      return UrlMetadata(
        title: 'Google',
        description:
            'A multinational technology company that specializes in Internet-related services and products.',
        faviconUrl: 'https://www.google.com/favicon.ico',
        safetyScore: 0.98, // Very Safe
      );
    } else if (url.contains('flutter.dev')) {
      return UrlMetadata(
        title: 'Flutter.dev',
        description:
            'The official documentation and resource hub for the Flutter framework.',
        faviconUrl: 'https://flutter.dev/favicon.ico',
        safetyScore: 0.99, // Very Safe
      );
    } else {
      // Return generic "safe" data for any other URL.
      return UrlMetadata(
        title: 'Website Link',
        description:
            'This link appears to be safe, but always browse with caution.',
        faviconUrl: '', // No icon
        safetyScore: 0.85, // Generally Safe
      );
    }
  }
}
