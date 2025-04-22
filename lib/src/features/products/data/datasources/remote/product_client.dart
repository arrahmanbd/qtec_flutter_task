import 'package:dio/dio.dart';
import 'package:qtec_flutter_task/src/features/products/data/models/product_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:qtec_flutter_task/src/core/constants/app_constants.dart';

part 'product_client.g.dart'; 


@RestApi(baseUrl: baseURL)
abstract class ProductClient {
  factory ProductClient(Dio dio, {String baseUrl}) = _ProductClient;

  @GET(productsEndpoint)
  Future<List<ProductModel>> getProducts();
}