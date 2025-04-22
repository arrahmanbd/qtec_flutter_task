

import 'package:dio/dio.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/resources/data_state.dart';
import 'package:qtec_flutter_task/src/features/products/domain/usecase/get_product_usecase.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/service_locator.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductUsecase getProductUsecase;
  ProductNotifier(this.getProductUsecase) : super(ProductLoading()) {
    fetchProducts();
  }
  Future<void> fetchProducts() async {
    try {
      final result = await getProductUsecase();
      log(result.data!.first.toString());
      if (result is DataSuccess) {
        state = ProductLoaded(result.data!);
      } else {
        state = ProductError(result.error!);
      }
    } catch (e) {
      state = ProductError(e as DioException);
    }
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(sl<GetProductUsecase>()),
);
