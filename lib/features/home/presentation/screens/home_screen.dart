import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/core/navigation/app_routes.dart';
import 'package:qrx_pro/core/services/settings/settings_service.dart';

/// This screen acts as the main shell with a BottomNavigationBar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _settingsService = getIt<SettingsService>();

  @override
  void initState() {
    super.initState();
    // Show the dialog after the first frame, using this widget's context
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showConsentDialogIfNeeded(),
    );
  }

  void _showConsentDialogIfNeeded() {
    // Ensure context is still valid before showing dialog
    if (!mounted) return;

    if (!_settingsService.hasSeenConsentDialog()) {
      showDialog(
        context: context, // Use the context from _HomeScreenState
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          // Use dialogContext for Navigator
          title: const Text('Analytics Consent'),
          content: const Text(
            'To help us improve the app, we collect anonymous usage data like feature interaction. Your personal data is never collected. Please see our Privacy Policy for more details.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                _settingsService.setConsentDialogSeen(true);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Decline'),
            ),
            FilledButton(
              onPressed: () {
                _settingsService.setConsentDialogSeen(true);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      );
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == AppRoutes.scan) return 1;
    if (location == AppRoutes.history) return 2;
    if (location == AppRoutes.settings) return 3;
    return 0;
  }

  void _onDestinationSelected(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.scan);
        break;
      case 2:
        context.go(AppRoutes.history);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) =>
            _onDestinationSelected(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.qrCode),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.scanLine),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
