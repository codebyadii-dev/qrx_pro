import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  const ScannerOverlayPainter({required this.scanWindow});

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: const Radius.circular(12),
          bottomRight: const Radius.circular(12),
        ),
      );

    // Creates a path that is the difference between the background and the cutout.
    // This results in a "hole" in the middle.
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);
    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    // Creates the border around the scan window.
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        scanWindow,
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: const Radius.circular(12),
        bottomRight: const Radius.circular(12),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
