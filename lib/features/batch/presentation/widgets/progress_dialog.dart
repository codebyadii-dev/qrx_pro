import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    super.key,
    required this.progressNotifier,
    required this.totalItems,
  });

  final ValueNotifier<int> progressNotifier;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generating Codes...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // This builder listens to the notifier and rebuilds the text and progress bar
          ValueListenableBuilder<int>(
            valueListenable: progressNotifier,
            builder: (context, value, child) {
              final double progress = totalItems > 0 ? value / totalItems : 0;
              return Column(
                children: [
                  Text('Generated $value of $totalItems QR codes.'),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: progress),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
