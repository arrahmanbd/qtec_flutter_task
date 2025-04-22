import 'dart:io';
import 'package:dio/dio.dart';
import 'package:qtec_flutter_task/src/core/resources/data_state.dart';
import 'package:qtec_flutter_task/src/features/products/data/datasources/local/local_data_source.dart';
import 'package:qtec_flutter_task/src/features/products/data/datasources/remote/remote_datasource.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/features/products/domain/repository/produtc_repository.dart';

class ProductRepositoryIMP implements ProductRepository {
  final LocalCache _localCache;
  final RemoteDataSource _remoteClient;

  ProductRepositoryIMP(this._localCache, this._remoteClient);

  @override
  Future<DataState<List<Product>>> getProducts() async {
    try {
      final httpResponse = await _remoteClient.getProducts();

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final products = httpResponse.data;
        // Save to cache
        await _localCache.cacheProducts(products);

        return DataSuccess(products);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      //  Load from cache on failure
      final cachedProducts = await _localCache.getCachedProducts();

      if (cachedProducts.isNotEmpty) {
        return DataSuccess(cachedProducts); // maybe add metadata: fromCache: true
      } else {
        return DataFailed(e);
      }
    }
  }
}
