import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrx_pro/core/config/app_theme.dart';
import 'package:qrx_pro/core/config/app_theme_mode.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/core/navigation/app_router.dart';
import 'package:qrx_pro/core/services/snackbar/snackbar_service.dart';
import 'package:qrx_pro/features/settings/presentation/cubit/settings_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final snackbarService = getIt<SnackbarService>();
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            scaffoldMessengerKey: snackbarService.messengerKey,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'QRX Pro',
            theme: AppTheme.lightTheme,
            darkTheme: state.themeMode == AppThemeMode.amoled
                ? AppTheme.amoledTheme
                : AppTheme.darkTheme,
            themeMode: _getThemeMode(state.themeMode),
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
      case AppThemeMode.amoled:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
