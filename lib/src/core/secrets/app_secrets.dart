import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static Map<String, String> _env = {};

  static Future<void> initializeEnv() async {
    final DotEnv dotEnv = DotEnv();
    await dotEnv.load();
    _env = dotEnv.env;
  }

  static String get apiKey => _env['API_KEY'] ?? '';
}
