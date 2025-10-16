// lib/app/view/app.dart
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRX Pro',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainScaffold(),
    );
  }
}

// A temporary placeholder widget for the home screen.
class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRX Pro - Phase 1')),
      body: const Center(
        child: Text(
          'Project Structure Initialized!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
