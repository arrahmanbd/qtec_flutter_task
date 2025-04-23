import 'package:flutter_addons/flutter_addons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qtec_flutter_task/src/features/products/data/models/product_model.dart';

class LocalCache {
  Future<void> cacheProducts(List<ProductModel> products) async {
    dbug('Cacheing');
    final box = await Hive.openBox('products');
    await box.put('list', products.map((e) => e.toJson()).toList());
  }

  Future<List<ProductModel>> getCachedProducts() async {
    dbug('Getting Cached');
    final box = await Hive.openBox('products');
    final List list = box.get('list', defaultValue: []);
    return list
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
