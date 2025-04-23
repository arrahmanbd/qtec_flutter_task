import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qtec_flutter_task/src/features/products/data/datasources/local/local_data_source.dart';
import 'package:qtec_flutter_task/src/features/products/data/datasources/remote/remote_datasource.dart';
import 'package:qtec_flutter_task/src/features/products/data/repository/product_repository_impliment.dart';
import 'package:qtec_flutter_task/src/features/products/domain/repository/produtc_repository.dart';
import 'package:qtec_flutter_task/src/features/products/domain/usecase/get_product_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
 
  // Dio
  sl.registerSingleton<Dio>(Dio());
  // Dependencies
  sl.registerSingleton<RemoteDataSource>(RemoteDataSource(sl()));
  sl.registerSingleton<LocalCache>(LocalCache());

  sl.registerSingleton<ProductRepository>(ProductRepositoryIMP(sl(), sl()));

  //UseCases
  sl.registerSingleton<GetProductUsecase>(GetProductUsecase(sl()));

 
}
