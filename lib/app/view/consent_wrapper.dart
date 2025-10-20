import 'package:flutter/material.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/core/services/settings/settings_service.dart';

class ConsentWrapper extends StatefulWidget {
  const ConsentWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<ConsentWrapper> createState() => _ConsentWrapperState();
}

class _ConsentWrapperState extends State<ConsentWrapper> {
  final _settingsService = getIt<SettingsService>();

  @override
  void initState() {
    super.initState();
    // Show the dialog after the first frame is built, if needed.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showConsentDialogIfNeeded(),
    );
  }

  void _showConsentDialogIfNeeded() {
    print("Consent already seen? ${_settingsService.hasSeenConsentDialog()}");
    if (!_settingsService.hasSeenConsentDialog()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Analytics Consent'),
          content: const Text(
            'To help us improve the app, we collect anonymous usage data like feature interaction. Your personal data is never collected. Please see our Privacy Policy for more details.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                _settingsService.setConsentDialogSeen(true);
                Navigator.of(context).pop();
              },
              child: const Text('Decline'),
            ),
            FilledButton(
              onPressed: () {
                // Here you would also save the consent choice, e.g., setAnalyticsEnabled(true)
                _settingsService.setConsentDialogSeen(true);
                Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
