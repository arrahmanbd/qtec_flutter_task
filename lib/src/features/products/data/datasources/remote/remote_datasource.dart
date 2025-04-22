import 'package:dio/dio.dart';
import 'package:qtec_flutter_task/src/features/products/data/models/product_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:qtec_flutter_task/src/core/constants/app_constants.dart';

part 'remote_datasource.g.dart'; 


@RestApi(baseUrl: baseURL)
abstract class RemoteDataSource {
  factory RemoteDataSource(Dio dio, {String baseUrl}) = _RemoteDataSource;

  @GET(productsEndpoint)
  Future<HttpResponse<List<ProductModel>>> getProducts();
}