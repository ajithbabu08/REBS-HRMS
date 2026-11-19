import 'environment.dart';

export 'environment.dart';

/// Global app configuration singleton.
///
/// Defaults to [AppConfig.dev]. Change by calling [initConfig]
/// before `runApp`.
AppConfig _config = AppConfig.dev;

AppConfig get appConfig => _config;

/// Initialise the app configuration.
///
/// Must be called before any service that depends on [appConfig].
void initConfig([Environment env = Environment.dev]) {
  switch (env) {
    case Environment.dev:
      _config = AppConfig.dev;
    case Environment.staging:
      _config = AppConfig.staging;
    case Environment.prod:
      _config = AppConfig.prod;
  }
}
