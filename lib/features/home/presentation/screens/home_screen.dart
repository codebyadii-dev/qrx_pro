// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrx_pro/core/navigation/app_routes.dart';
import 'package:qrx_pro/features/home/presentation/widgets/scanner_overlay_painter.dart';

/// This screen acts as the main shell with a BottomNavigationBar.
/// It is now a StatelessWidget because GoRouter manages the navigation state.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  /// Calculates the selected index of the NavigationBar based on the current route.
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == AppRoutes.scan) {
      return 1;
    }
    if (location == AppRoutes.history) {
      return 2;
    }
    if (location == AppRoutes.settings) {
      return 3;
    }
    // Default to home
    return 0;
  }

  /// Navigates to the selected route when a destination is tapped.
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
      body: child, // The active screen from GoRouter is displayed here
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) =>
            _onDestinationSelected(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.home), label: 'Home'),
          NavigationDestination(icon: Icon(LucideIcons.qrCode), label: 'Scan'),
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

// --- Placeholder Tabs (Unchanged) ---

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Home Content')),
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History Screen')),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

// --- YOUR FIXED SCANNER TAB (Unchanged) ---

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _cameraController,
            builder: (context, state, child) {
              final torchState = state.torchState;
              return IconButton(
                onPressed: () => _cameraController.toggleTorch(),
                icon: torchState == TorchState.on
                    ? const Icon(LucideIcons.zap, color: Colors.yellow)
                    : const Icon(LucideIcons.zapOff, color: Colors.grey),
              );
            },
          ),
          IconButton(
            onPressed: () => _cameraController.switchCamera(),
            icon: const Icon(LucideIcons.rotateCw),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _cameraController,
            scanWindow: scanWindow,
            onDetect: (capture) {
              // Logic to be added in Phase 9
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
          ),
          CustomPaint(painter: ScannerOverlayPainter(scanWindow: scanWindow)),
        ],
      ),
    );
  }
}
