import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/provider.dart';

// State
class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
          id: id ?? this.id,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving,
          product: product ?? this.product);
}

// Notifier
class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;
  ProductNotifier({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    // Apenase se contrulla llama al metodo loadProduct
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      final product = await productsRepository.getProductById(state.id);
      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

// Provider
//* autoDispose para que se limpie cada vez que no se va a utlizar
//* family Para esperar un valor cuando se vaya a utilizar
final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductNotifier(
      productsRepository: productsRepository, productId: productId);
});
