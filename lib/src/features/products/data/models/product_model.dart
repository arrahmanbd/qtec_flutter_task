import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'image': image,
  };

  factory ProductModel.fake() => ProductModel(
    id: 1,
    title: 'Fake Product',
    image: 'https://placehold.co/600x400/png',
    price: 99.99,
  );
}
