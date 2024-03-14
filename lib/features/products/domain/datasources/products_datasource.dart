import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsDataSource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProductByTerm(String id);
  Future<Product> createUpdatedProduct(Map<String, dynamic> productLike);
}
