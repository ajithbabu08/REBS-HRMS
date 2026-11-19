import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/config/environment.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Read environment configuration with dart-define override support
  const config = AppConfig.dev;

  // Initialize service locator and dependencies
  await setupServiceLocator(config: config);

  runApp(const RebsHrmsApp());
}
