// lib/app/view/app.dart
import 'package:flutter/material.dart';
import 'package:qrx_pro/core/config/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRX Pro',
      // Connect our custom themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // The theme mode will be managed by a Cubit in a later .
      // For now, it will follow the system setting.
      themeMode: ThemeMode.system,
      home: const MainScaffold(),
    );
  }
}

// This temporary placeholder remains the same.
class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRX Pro - Phase 2')),
      body: const Center(
        child: Text('Themes Initialized!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
