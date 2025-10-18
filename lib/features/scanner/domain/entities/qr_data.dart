// The types of QR data we can now recognize.
enum QrDataType { url, text, wifi, vcard, email, phone, sms, geo, unknown }

// Base class for parsed data (remains the same).
abstract class ParsedQrData {
  final String rawValue;
  ParsedQrData(this.rawValue);
}

// WiFi data class (remains the same).
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

// Generic data class for text and other simple types.
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

  // The parser is now much smarter, thanks to your list!
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
    if (value.startsWith('mailto:')) {
      return QrDataType.email;
    }
    if (value.startsWith('tel:')) {
      return QrDataType.phone;
    }
    if (value.startsWith('sms:') || value.startsWith('smsto:')) {
      return QrDataType.sms;
    }
    if (value.startsWith('geo:')) {
      return QrDataType.geo;
    }
    return QrDataType.text;
  }

  // This method dispatches to the correct parser.
  static ParsedQrData _parseData(String rawValue) {
    final type = _parseType(rawValue);
    switch (type) {
      case QrDataType.wifi:
        return _parseWifi(rawValue);
      // For now, these will be handled as simple text with special icons/actions.
      // Full parsers will be added later.
      case QrDataType.vcard:
      case QrDataType.url:
      case QrDataType.text:
      case QrDataType.email:
      case QrDataType.phone:
      case QrDataType.sms:
      case QrDataType.geo:
      default:
        return TextData(rawValue);
    }
  }

  // WiFi parser (remains the same).
  static WifiData _parseWifi(String rawValue) {
    String ssid = '';
    String password = '';
    String encryption = 'WPA';

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
