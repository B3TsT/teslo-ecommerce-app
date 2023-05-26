import 'package:dio/dio.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../../../../infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final DioClient dioClient;
  AuthDataSourceImpl({DioClient? dioClient})
      : dioClient = dioClient ?? DioClient();

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dioClient.dio
          .post('/auth/login', data: {"email": email, "password": password});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credinciales incorrectas');
      }
      if (e.type == DioErrorType.connectionTimeout) throw ConnectionError();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dioClient.dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credinciales incorrectas');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
