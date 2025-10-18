class UrlMetadata {
  final String title;
  final String description;
  final String faviconUrl;
  final double safetyScore; // A score from 0.0 to 1.0

  UrlMetadata({
    required this.title,
    required this.description,
    required this.faviconUrl,
    required this.safetyScore,
  });
}
