import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../../../../infrastructure/infrastructure.dart';
import '../errors/product_errors.dart';
import '../mappers/products_mapper.dart';

class ProductsDatasourceImpl extends ProductsDataSource {
  final Dio dioClient;
  final String accessToken;
  ProductsDatasourceImpl({Dio? dioClient, required this.accessToken})
      : dioClient =
            dioClient ?? DioClient().dioBearer(accessToken: accessToken);
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? id = productLike['id'];
      final String method = id == null ? 'POST' : 'PATCH';
      final String url = id == null ? '/products' : '/products/$id';
      productLike.remove('id');

      final response = await dioClient.request(
        url,
        data: productLike,
        options: Options(method: method),
      );

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductsById(String id) async {
    try {
      final response = await dioClient.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFount();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dioClient.get<List>('/products', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
