import 'package:dio/dio.dart';
import 'package:qtec_flutter_task/src/features/products/data/models/product_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:qtec_flutter_task/src/core/constants/api_constants.dart';

part 'remote_datasource.g.dart';


final dio = Dio(BaseOptions(
  baseUrl: baseURL,
  connectTimeout: const Duration(seconds: 10), // Timeout to connect to server
  receiveTimeout: const Duration(seconds: 10), // Timeout for receiving data
  sendTimeout: const Duration(seconds: 10),    // Timeout for sending request
));


@RestApi(baseUrl: baseURL)
abstract class RemoteDataSource {
  factory RemoteDataSource(Dio dio, {String baseUrl}) = _RemoteDataSource;

  @GET(productsEndpoint)
  Future<HttpResponse<List<ProductModel>>> getProducts();
}
