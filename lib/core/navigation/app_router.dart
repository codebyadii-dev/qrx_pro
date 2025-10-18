import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrx_pro/core/navigation/app_routes.dart';
import 'package:qrx_pro/features/batch/presentation/screens/batch_generator_screen.dart';
import 'package:qrx_pro/features/generator/presentation/screens/generator_screen.dart';
import 'package:qrx_pro/features/generator/presentation/screens/preview_screen.dart';
import 'package:qrx_pro/features/history/presentation/screens/history_screen.dart';
import 'package:qrx_pro/features/home/presentation/screens/home_screen.dart';
import 'package:qrx_pro/features/scanner/presentation/screens/result_screen.dart';
import 'package:qrx_pro/features/scanner/presentation/screens/scanner_screen.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: _rootNavigatorKey,
    routes: [
      // ShellRoute for main navigation with BottomNavigationBar
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          // Home Tab
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const GeneratorScreen(),
          ),
          // Scan Tab
          GoRoute(
            path: AppRoutes.scan,
            builder: (context, state) => const ScannerScreen(),
          ),
          // History Tab
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const HistoryScreen(),
          ),
          // Settings Tab
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsTab(),
          ),
        ],
      ),
      // We can add other top-level routes here later (e.g., login, onboarding)
      GoRoute(
        path: '/scan/result', // Define a clear path
        builder: (context, state) {
          // Pass the scanned data to the screen using 'extra'
          final String qrData = state.extra as String? ?? 'No data found';
          return ResultScreen(qrData: qrData);
        },
      ),
      GoRoute(
        path: '/generator/preview',
        builder: (context, state) {
          final String data = state.extra as String? ?? 'Error';
          return PreviewScreen(data: data); // Pass only the data
        },
      ),
      GoRoute(
        path: '/generator/batch',
        builder: (context, state) => const BatchGeneratorScreen(),
      ),
    ],
  );
}
