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

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName),
      });
      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadPhotos(List<String> photos) async {
    final photosToUpload =
        photos.where((element) => element.contains('/')).toList();
    final photosToIgnore =
        photos.where((element) => !element.contains('/')).toList();
    // Crear una serie de futures de carga de imagenes
    final List<Future<String>> uploadJob =
        photosToUpload.map((e) => _uploadFile(e)).toList();
    final newImages = await Future.wait(uploadJob);
    return [...photosToIgnore, ...newImages];
  }

  @override
  Future<Product> createUpdatedProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url =
          (productId == null) ? '/products' : '/products/$productId';
      productLike.remove('id');
      productLike['images'] = await _uploadPhotos(productLike['images']);
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
