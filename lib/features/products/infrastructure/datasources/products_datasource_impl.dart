import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDataSourceImpl extends ProductsDataSource {
  late final Dio dio;
  final String accessToken;

  ProductsDataSourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  @override
  Future<Product> createUpdatedProduct(Map<String, dynamic> productLike) {
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio.get('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final producto in response.data ?? []) {
      // Mapper
      products.add(ProductMapper.jsonToEntity(producto));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String id) {
    throw UnimplementedError();
  }
}
