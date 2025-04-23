import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';


class ProductState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool isFinished;
  final DioException? error;

  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isFinished = false,
    this.error,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? isFinished,
    DioException? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFinished: isFinished ?? this.isFinished,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        products,
        isLoading,
        isLoadingMore,
        isRefreshing,
        isFinished,
        error,
      ];
}
