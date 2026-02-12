import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';
import 'providers/providers.dart';
import 'navigation/navigation.dart';

void main() {
  runApp(const CuisinVoisinApp());
}

class CuisinVoisinApp extends StatelessWidget {
  const CuisinVoisinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "Cuisin'Voisin",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.lightBackground,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
              ),
              fontFamily: 'System',
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.darkBackground,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
              ),
              fontFamily: 'System',
            ),
            themeMode: _convertThemeMode(themeProvider.themeMode),
            initialRoute: '/splash',
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }

  ThemeMode _convertThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
