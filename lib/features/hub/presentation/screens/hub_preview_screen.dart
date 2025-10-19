import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/features/hub/domain/entities/hub_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HubPreviewScreen extends StatelessWidget {
  const HubPreviewScreen({super.key, required this.hubPage});

  final HubPage hubPage;

  @override
  Widget build(BuildContext context) {
    // This is the unique link for the hub page.
    // For now, it's a placeholder. Later, this could be a real URL.
    final hubLink = 'qrxpro://hub/${hubPage.id}';

    return Scaffold(
      appBar: AppBar(title: const Text('Hub Page Preview')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // The Hub Page Card Preview
          _buildHubCard(context),
          const SizedBox(height: 32),
          // The QR Code for the Hub Page
          Center(
            child: QrImageView(
              data: hubLink,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Scan this code to view your Hub Page',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  /* Future: Save QR to gallery */
                },
                icon: const Icon(LucideIcons.download),
                label: const Text('Save QR'),
              ),
              const SizedBox(width: 16),
              FilledButton.tonalIcon(
                onPressed: () {
                  /* Future: Share QR */
                },
                icon: const Icon(LucideIcons.share2),
                label: const Text('Share QR'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHubCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image
          if (hubPage.imagePath != null)
            Container(
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(hubPage.imagePath!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  hubPage.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (hubPage.description.isNotEmpty)
                  Text(
                    hubPage.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                if (hubPage.primaryLink.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        /* Future: Open primary link */
                      },
                      icon: const Icon(LucideIcons.link),
                      label: const Text('Visit My Link'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
