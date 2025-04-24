// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:qtec_flutter_task/src/core/error/failure.dart';

import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';

class ProductState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool isFinished;
  final bool isempty;
  final AppFailure? error;


  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isFinished = false,
    this.isempty = false,
    this.error,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? isFinished,
    bool? isempty,
    AppFailure? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFinished: isFinished ?? this.isFinished,
      isempty: isempty ?? this.isempty,
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
    isempty,
  ];
}
