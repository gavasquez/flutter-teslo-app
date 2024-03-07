import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironmen() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'no esta configurada el Api_url';
}
