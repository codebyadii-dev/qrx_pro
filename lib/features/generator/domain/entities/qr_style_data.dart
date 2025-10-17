import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrStyleData {
  final Color foregroundColor;
  final Color backgroundColor;
  final QrEyeShape eyeShape;

  QrStyleData({
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.eyeShape = QrEyeShape.square,
  });
}
