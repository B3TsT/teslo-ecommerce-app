import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../config.dart';

class EnvConstants {
  static initEnv() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? apiUrlNotFound;
}
