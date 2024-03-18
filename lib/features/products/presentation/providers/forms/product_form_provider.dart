import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

// State
class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.sizes = const [],
      this.gender = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        description: description ?? this.description,
        gender: gender ?? this.gender,
        id: id ?? this.id,
        images: images ?? this.images,
        inStock: inStock ?? this.inStock,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        slug: slug ?? this.slug,
        tags: tags ?? this.tags,
        title: title ?? this.title,
      );
}

// Notifier
class ProductoFormNotifier extends StateNotifier<ProductFormState> {
  final Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductoFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          inStock: Stock.dirty(product.stock),
          price: Price.dirty(product.price),
          description: product.description,
          gender: product.gender,
          images: product.images,
          sizes: product.sizes,
          tags: product.tags.join(','),
        ));

  Future<bool> onFormSubmit() async {
    // Tocamos cada uno de los campos para que tenga sus validaciones
    _touchedEveryThing();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;
    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'stock': state.inStock.value,
      'slug': state.slug.value,
      'tags': state.tags.split(','),
      'description': state.description,
      'gender': state.gender,
      'sizes': state.sizes,
      'images': state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList(),
    };
    //* Llamar on submir callback
    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryThing() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
        Slug.dirty(state.slug.value),
      ]),
    );
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Stock.dirty(state.inStock.value),
          Price.dirty(state.price.value),
        ]));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Slug.dirty(value),
          Title.dirty(state.title.value),
          Stock.dirty(state.inStock.value),
          Price.dirty(state.price.value),
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Price.dirty(value),
          Slug.dirty(state.slug.value),
          Title.dirty(state.title.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onStockChanged(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Stock.dirty(value),
          Price.dirty(state.price.value),
          Slug.dirty(state.slug.value),
          Title.dirty(state.title.value),
        ]));
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes,
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }

  void onDescriptionChanged(String descripcion) {
    state = state.copyWith(
      description: descripcion,
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags,
    );
  }
}

// Provider
// autoDispose que se limpie cuando no se necesita
// family el tipo de dato
final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductoFormNotifier, ProductFormState, Product>((ref, productId) {
  // Funcion para grabar la data, createUpdateCallback
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdatedProduct;
  return ProductoFormNotifier(
    product: productId,
    //* Configurarlo
    //onSubmitCallback:
    onSubmitCallback: createUpdateCallback,
  );
});
