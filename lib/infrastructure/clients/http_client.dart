import 'package:dio/dio.dart';

//* THIS FILE IS A COPY OF lib\infrastructure\clients\dio_client.dart
class HttpClient {
  static final Dio _dio =
      Dio(); //* <-- Aquí puedes configurar las opciones de Dio según tus necesidades

  Dio get dio => _dio;
  // Utiliza dio para realizar las solicitudes HTTP u otras operaciones necesarias
}
