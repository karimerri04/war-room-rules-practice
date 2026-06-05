/// API configuration for the Flutter frontend.
///
/// For Flutter Web and desktop running on the same machine as the backend,
/// localhost works as expected.
///
/// For Android emulator, replace localhost with `10.0.2.2`.
class ApiConfig {
  static const String baseUrl = 'http://localhost:8081/api/java-incidents';

  const ApiConfig._();
}