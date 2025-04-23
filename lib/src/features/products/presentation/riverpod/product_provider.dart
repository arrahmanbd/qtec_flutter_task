

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/resources/data_state.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/features/products/domain/usecase/get_product_usecase.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/service_locator.dart';
import 'package:qtec_flutter_task/src/shared/utils/product_filter_utils.dart';
import 'package:qtec_flutter_task/src/shared/utils/sort_order.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(sl<GetProductUsecase>()),
);


class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductUsecase getProductUsecase;

  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];

  SortOrder _currentSort = SortOrder.lowToHigh;
  String _currentQuery = '';

  ProductNotifier(this.getProductUsecase) : super(ProductLoading()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final result = await getProductUsecase();
      if (result is DataSuccess && result.data != null) {
        _allProducts = result.data!;
        _applyFilters();
      } else {
        state = ProductError(result.error!);
      }
    } catch (e) {
      state = ProductError(e as DioException);
    }
  }

  void search(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  void sort(SortOrder order) {
    _currentSort = order;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = ProductFilterUtils.search(_allProducts, _currentQuery);
    var sorted = ProductFilterUtils.sort(filtered, _currentSort);
    _displayedProducts = sorted;
    state = ProductLoaded(_displayedProducts);
  }
}
