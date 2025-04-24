import 'package:dio/dio.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/resources/data_state.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/features/products/domain/usecase/get_product_usecase.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/service_locator.dart';
import 'package:qtec_flutter_task/src/shared/utils/product_filter_utils.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(sl<GetProductUsecase>()),
);

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductUsecase getProductUsecase;

  int _page = 0;
  final int _pageSize = 10;

  List<Product> _allProducts = [];
  SortOrder _currentSort = SortOrder.priceLowToHigh;
  String _currentQuery = '';

  ProductNotifier(this.getProductUsecase) : super(const ProductState()) {
    fetchInitialProducts();
  }

  // Initial fetch of products
  Future<void> fetchInitialProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    _page = 0; // Reset to page 0 when fetching initial products.
    _allProducts.clear();

    try {
      final result = await getProductUsecase();
      if (result is DataSuccess && result.data != null) {
        _allProducts = result.data!;
        _page = 1;
        _applyFilters();
      } else {
        state = state.copyWith(isLoading: false, error: result.error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e as DioException);
    }
  }

  // Load more products for pagination
  Future<bool> loadMore() async {
    if (state.isLoadingMore || state.isFinished) return true;
    state = state.copyWith(isLoadingMore: true);
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulating network delay
    // Increment the page to load the next set of products
    _page++;
    dbug('Load more products for page $_page');
    _applyFilters();
    return false;
  }

  // Apply filters and pagination to the products list
  void _applyFilters() {
    var filtered = ProductFilterUtils.search(_allProducts, _currentQuery);
    var sorted = ProductFilterUtils.sort(filtered, _currentSort);
    // Paginate based on the current page and page size
    var paginated = sorted.take(_page * _pageSize).toList();
    state = state.copyWith(
      products: paginated,
      isLoading: false,
      isRefreshing: false,
      isLoadingMore: false,
      isempty: false,
      isFinished:
          paginated.length >= sorted.length, // Check if all products are loaded
    );
  }

  // Refresh the product list
  Future<void> refresh() async {
    state = state.copyWith(
      isRefreshing: true,
      error: null, // optional, clear error on refresh
      isLoading: false,
      isLoadingMore: false,
      // Remove `isempty: true`, let _applyFilters decide this later
    );

    await Future.delayed(const Duration(milliseconds: 800));

    _page = 0;
    _allProducts.clear();

    await fetchInitialProducts(); // already calls _applyFilters
    clearFilters();
  }

  // Search functionality
  void search(String query) {
    _currentQuery = query;
    _applyFilters();
  }

  // Sort functionality
  void sort(SortOrder order) {
    _currentSort = order;
    _applyFilters();
  }

  // Clear filters
  void clearFilters() {
    _currentQuery = '';
    _currentSort = SortOrder.idAsc;
    _applyFilters();
  }
}
