import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrx_pro/features/generator/domain/entities/qr_style_data.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.data, required this.style});

  final String data;
  final QrStyleData style;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Preview')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                color:
                    style.backgroundColor, // Use background color for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    size: 250.0,
                    gapless: false,
                    // *** APPLY THE STYLES HERE ***
                    eyeStyle: QrEyeStyle(
                      eyeShape: style.eyeShape,
                      color: style.foregroundColor,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape:
                          QrDataModuleShape.square, // Keep data modules square
                      color: style.foregroundColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      /* Phase 19 */
                    },
                    icon: const Icon(LucideIcons.download),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      /* Phase 19 */
                    },
                    icon: const Icon(LucideIcons.share2),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
