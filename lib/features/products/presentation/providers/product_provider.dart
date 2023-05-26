import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';

//* Provider de editar o visualizar un producto

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>(
  (ref, productId) {
    // final productId = ref.watch(productIdProvider);
    return ProductNotifier(
      productsRepository: ref.watch(productsRepositoryProvider),
      productId: productId,
    );
  },
);

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }
  final ProductsRepository productsRepository;

  Product newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      slug: '',
      stock: 0,
      sizes: [],
      gender: 'men',
      tags: [],
      images: [],
    );
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: newEmptyProduct(),
        );
        return;
      }
      final product = await productsRepository.getProductsById(state.id);
      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      // state = state.copyWith(isLoading: false);
      print(e);
    }
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
