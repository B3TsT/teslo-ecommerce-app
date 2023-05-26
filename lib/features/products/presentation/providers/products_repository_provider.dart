import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>(
  (ref) {
    final productsRepository = ProductsRepositoryImpl(
      ProductsDatasourceImpl(
        accessToken: ref.watch(authProvider).user?.token ?? '',
      ),
    );
    return productsRepository;
  },
);
