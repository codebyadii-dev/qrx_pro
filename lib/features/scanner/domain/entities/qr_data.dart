// The types of QR data we can recognize.
enum QrDataType { url, text, wifi, vcard, unknown }

// A base class for our parsed data.
abstract class ParsedQrData {
  final String rawValue;
  ParsedQrData(this.rawValue);
}

// Specific data class for WiFi credentials.
class WifiData extends ParsedQrData {
  final String ssid;
  final String password;
  final String encryption;
  WifiData({
    required String rawValue,
    required this.ssid,
    required this.password,
    required this.encryption,
  }) : super(rawValue);
}

// Specific data class for plain text.
class TextData extends ParsedQrData {
  TextData(super.rawValue);
}

// The main entity that holds our parsed data.
class QrData {
  final String rawValue;
  final QrDataType type;
  final ParsedQrData parsedData;

  QrData({required this.rawValue})
    : type = _parseType(rawValue),
      parsedData = _parseData(rawValue);

  static QrDataType _parseType(String value) {
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return QrDataType.url;
    }
    if (value.startsWith('WIFI:')) {
      return QrDataType.wifi;
    }
    if (value.startsWith('BEGIN:VCARD')) {
      return QrDataType.vcard;
    }
    return QrDataType.text;
  }

  // This method dispatches to the correct parser.
  static ParsedQrData _parseData(String rawValue) {
    final type = _parseType(rawValue);
    switch (type) {
      case QrDataType.wifi:
        return _parseWifi(rawValue);
      // We will add vCard parsing later. For now, it's treated as text.
      case QrDataType.vcard:
      case QrDataType.url:
      case QrDataType.text:
      default:
        return TextData(rawValue);
    }
  }

  // A simple parser for WiFi strings.
  static WifiData _parseWifi(String rawValue) {
    String ssid = '';
    String password = '';
    String encryption = 'WPA'; // Default

    final parts = rawValue.substring(5).split(';');
    for (var part in parts) {
      if (part.startsWith('S:')) {
        ssid = part.substring(2);
      } else if (part.startsWith('P:')) {
        password = part.substring(2);
      } else if (part.startsWith('T:')) {
        encryption = part.substring(2);
      }
    }
    return WifiData(
      rawValue: rawValue,
      ssid: ssid,
      password: password,
      encryption: encryption,
    );
  }
}
