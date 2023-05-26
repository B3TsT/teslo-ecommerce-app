import 'dart:io';

import '../../infrastructure/clients/dio_client.dart';
import 'package:flutter/material.dart';

abstract class ConnectionServiceDatasource {
  Future<dynamic> client(String endpoint, dynamic body);
  Future<dynamic> login(String endpoint, dynamic body);
  Future<dynamic> register(String endpoint, dynamic body);
  Future<dynamic> getProduct(String endpoint, dynamic body);
}

abstract class ConnectionServiceRepository {
  Future<dynamic> login(String endpoint, dynamic body);
  Future<dynamic> register(String endpoint, dynamic body);
  Future<dynamic> getProduct(String endpoint, dynamic body);
}

class ClientWithDioDatasourceImpl implements ConnectionServiceDatasource {
  final DioClient dioClient;

  ClientWithDioDatasourceImpl({DioClient? dioClient})
      : dioClient = dioClient ?? DioClient();

  @override
  Future client(String endpoint, body) async {}

  @override
  Future<dynamic> login(String endpoint, dynamic body) async {
    final response = await dioClient.dio.post(endpoint, data: body);
    return response.data;
  }

  @override
  Future<dynamic> register(String endpoint, dynamic body) async {
    final response = await dioClient.dio.post(endpoint, data: body);
    return response.data;
  }

  @override
  Future<dynamic> getProduct(String endpoint, dynamic body) async {
    final response = await dioClient.dio.get(endpoint, queryParameters: body);
    return response.data;
  }
}

class ClientWithHttpDatasourceImpl implements ConnectionServiceDatasource {
  final HttpClient httpClient;

  ClientWithHttpDatasourceImpl({HttpClient? httpClient})
      : httpClient = httpClient ?? HttpClient();

  @override
  Future<dynamic> login(String endpoint, dynamic body) async {
    // Implementa el código correspondiente para realizar la solicitud HTTP con HttpClient
  }

  @override
  Future<dynamic> register(String endpoint, dynamic body) async {
    // Implementa el código correspondiente para realizar la solicitud HTTP con HttpClient
  }

  @override
  Future<dynamic> getProduct(String endpoint, dynamic body) async {
    // Implementa el código correspondiente para realizar la solicitud HTTP con HttpClient
  }

  @override
  Future client(String endpoint, body) async {
    //
  }
}

class ConnectionServiceRepositoryImpl extends ConnectionServiceRepository {
  final ConnectionServiceDatasource datasource;
  ConnectionServiceRepositoryImpl({ConnectionServiceDatasource? datasource})
      : datasource = datasource ?? ClientWithDioDatasourceImpl();

  @override
  Future getProduct(String endpoint, body) async {
    return await datasource.getProduct(endpoint, body);
  }

  @override
  Future login(String endpoint, body) async {
    return await datasource.login(endpoint, body);
  }

  @override
  Future register(String endpoint, body) {
    throw UnimplementedError();
  }
}

class Utili {
  jhdsa() {
    final client = DioClient();
    final http = HttpClient();

    Future<dynamic> clientDio = ConnectionServiceRepositoryImpl(
      datasource: ClientWithDioDatasourceImpl(dioClient: client),
    ).login('endpoint', []);

    Future<dynamic> clientHttp = ConnectionServiceRepositoryImpl(
      datasource: ClientWithHttpDatasourceImpl(httpClient: http),
    ).login('endpoint', []);

    Future<dynamic> defaultService =
        ConnectionServiceRepositoryImpl().login('endpoint', []);

    debugPrint('$clientDio');
    debugPrint('$clientHttp');
    debugPrint('$defaultService');
  }
}
