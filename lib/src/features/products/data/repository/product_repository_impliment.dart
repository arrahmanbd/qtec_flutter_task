import 'package:qtec_flutter_task/src/core/resources/data_state.dart';
import 'package:qtec_flutter_task/src/features/products/data/datasources/local/local_data_source.dart';
import 'package:qtec_flutter_task/src/features/products/data/datasources/remote/product_client.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/features/products/domain/repository/produtc_repository.dart';

class ProductRepositoryIMP implements ProductRepository{
  final LocalCache localCache;
  final ProductClient productClient;
  ProductRepositoryIMP({
    required this.localCache,
    required this.productClient,
  });

  @override
  Future<DataState<List<Product>>> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }
  
}