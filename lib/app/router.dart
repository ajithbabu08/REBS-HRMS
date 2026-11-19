import 'package:flutter/material.dart';

import 'main_shell.dart';
import '../features/leave/presentation/pages/apply_leave_page.dart';
import '../features/settings/presentation/pages/debug_panel_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String applyLeave = '/apply-leave';
  static const String debugPanel = '/debug';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => const MainShell());
      case applyLeave:
        final employeeId = settings.arguments as String? ?? 'REBS-EMP-001';
        return MaterialPageRoute(
          builder: (_) => ApplyLeavePage(employeeId: employeeId),
        );
      case debugPanel:
        return MaterialPageRoute(builder: (_) => const DebugPanelPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
