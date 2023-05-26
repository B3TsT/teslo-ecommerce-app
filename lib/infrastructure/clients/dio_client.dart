import 'package:dio/dio.dart';

import '../../config/config.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvConstants.apiUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ); //* <-- Aquí puedes configurar las opciones de Dio según tus necesidades

  Dio get dio => _dio;

  dioBearer({String? accessToken}) {
    return Dio(
      BaseOptions(
        baseUrl: EnvConstants.apiUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken ?? ''}',
        },
      ),
    );
  }
}
