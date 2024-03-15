import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

class ProductsDataSourceImpl extends ProductsDataSource {
  late final Dio dio;
  final String accessToken;

  ProductsDataSourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  @override
  Future<Product> createUpdatedProduct(Map<String, dynamic> productLike) async {
    try {
      final String productId = productLike['id'];
      // ignore: unnecessary_null_comparison
      final String method = (productId == null) ? 'POST' : 'PATH';
      // ignore: unnecessary_null_comparison
      final String url = (productId == null) ? '/post' : '/products/$productId';
      productLike.remove('id');
      final response = await dio.request(
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
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
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
