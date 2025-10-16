// lib/app/view/app.dart
import 'package:flutter/material.dart';
import 'package:qrx_pro/core/config/app_theme.dart';
import 'package:qrx_pro/core/navigation/app_router.dart'; // Import the router

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Change to MaterialApp.router
    return MaterialApp.router(
      routerConfig: AppRouter.router, // Provide the router configuration
      debugShowCheckedModeBanner: false,
      title: 'QRX Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
