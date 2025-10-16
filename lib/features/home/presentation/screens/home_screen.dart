import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// This screen will act as the main shell with a BottomNavigationBar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  // The child widget to be displayed in the body, determined by GoRouter.
  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // A simple placeholder for the selected index. GoRouter will manage state.
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // The active screen is injected here
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          // Placeholder navigation logic. This will be connected to GoRouter later.
          setState(() {
            _currentIndex = index;
          });
        },
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

// A temporary widget to show on the home tab
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

// And for the other tabs
class ScanTab extends StatelessWidget {
  const ScanTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: const Center(child: Text('Scanner Screen')),
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
