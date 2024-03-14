import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) => Product(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes'].map((size) => size)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((size) => size)),
      images: List<String>.from(json['images'].map((image) =>
          // Si la imagen comienza con http
          image.startsWith('http')
              ? image
              : '${Environment.apiUrl}/files/product/$image')),
      user: UserMapper.userJsonToEntity(json['user']));
}
