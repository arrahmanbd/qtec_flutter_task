import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';

abstract class ProductState extends Equatable{
  final List<Product> products;
  final DioException? error;
  const ProductState({this.products = const [], this.error});
  @override
  List<Object?> get props => [products, error]; 
}


class ProductLoading extends ProductState {
  const ProductLoading();
}
class ProductLoaded extends ProductState {
  const ProductLoaded(List<Product> products):super(products: products);
}
class ProductError extends ProductState {
  const ProductError(DioException error):super(error: error);
}