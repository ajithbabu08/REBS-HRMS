import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class RebsHrmsApp extends StatelessWidget {
  const RebsHrmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REBS HRMS',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
