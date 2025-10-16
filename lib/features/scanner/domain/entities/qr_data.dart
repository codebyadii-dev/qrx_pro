enum QrDataType { url, text, unknown }

class QrData {
  final String rawValue;
  final QrDataType type;

  QrData({required this.rawValue}) : type = _parseType(rawValue);

  static QrDataType _parseType(String value) {
    final uri = Uri.tryParse(value);
    if (uri != null && (uri.isScheme('HTTP') || uri.isScheme('HTTPS'))) {
      return QrDataType.url;
    }
    return QrDataType.text;
  }
}
