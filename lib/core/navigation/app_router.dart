import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrx_pro/core/navigation/app_routes.dart';
import 'package:qrx_pro/features/home/presentation/screens/home_screen.dart';

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
            builder: (context, state) => const HomeTab(),
          ),
          // Scan Tab
          GoRoute(
            path: AppRoutes.scan,
            builder: (context, state) => const ScanTab(),
          ),
          // History Tab
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const HistoryTab(),
          ),
          // Settings Tab
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsTab(),
          ),
        ],
      ),
      // We can add other top-level routes here later (e.g., login, onboarding)
    ],
  );
}
