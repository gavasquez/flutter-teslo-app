import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/produts_repository.impl.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRepostory = ProductsRepositoryImpl(
    ProductsDataSourceImpl(accessToken: accessToken),
  );
  return productsRepostory;
});
