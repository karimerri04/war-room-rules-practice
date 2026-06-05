import 'package:flutter/foundation.dart';

/// API configuration for the Flutter frontend.
///
/// Flutter Web can use localhost because it runs inside the host browser.
/// Android emulator must use 10.0.2.2 to reach the host machine.
class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8081/api/java-incidents';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8081/api/java-incidents';
    }

    return 'http://localhost:8081/api/java-incidents';
  }

  const ApiConfig._();
}