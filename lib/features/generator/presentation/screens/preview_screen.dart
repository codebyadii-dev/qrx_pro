import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.data});

  final String data;

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
              // This is the widget that renders the QR code
              Card(
                elevation: 2,
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
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Placeholder buttons for future features
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      // Logic for Phase 19
                    },
                    icon: const Icon(LucideIcons.download),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      // Logic for Phase 19
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
