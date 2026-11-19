/// App environment configuration for REBS HRMS.
enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final double officeLatitude;
  final double officeLongitude;
  final double officeRadiusMeters;
  final String companyTimezone;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final double? debugLatitude;
  final double? debugLongitude;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.officeLatitude = 10.0303,
    this.officeLongitude = 76.3358,
    this.officeRadiusMeters = 200.0,
    this.companyTimezone = 'Asia/Kolkata',
    this.connectTimeout = const Duration(seconds: 3),
    this.receiveTimeout = const Duration(seconds: 5),
    this.debugLatitude,
    this.debugLongitude,
  });

  /// Default dev configuration.
  /// Supports override via `--dart-define=API_BASE_URL=...`
  static const AppConfig dev = AppConfig(
    environment: Environment.dev,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000',
    ),
  );

  static const AppConfig staging = AppConfig(
    environment: Environment.staging,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://staging-api.rebs.com',
    ),
  );

  static const AppConfig prod = AppConfig(
    environment: Environment.prod,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://rebs-hrms.onrender.com',
    ),
  );

  bool get isDebug => environment == Environment.dev;

  /// Whether to use debug location override instead of real GPS.
  bool get hasDebugLocationOverride =>
      debugLatitude != null && debugLongitude != null;
}
