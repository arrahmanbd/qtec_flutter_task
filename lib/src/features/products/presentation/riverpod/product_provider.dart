import 'package:dio/dio.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/error/failure.dart';
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
  bool get isSearching => _currentQuery.isNotEmpty;
  ProductNotifier(this.getProductUsecase) : super(const ProductState()) {
    fetchInitialProducts();
  }

  Future<void> fetchInitialProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    _page = 0;
    _allProducts.clear();

    try {
      final result = await getProductUsecase();

      if (result is DataSuccess && result.data != null) {
        _allProducts = result.data!;
        _page = 1;

        /// If data fetch is successful, clear error regardless of content
        state = state.copyWith(error: null);

        _applyFilters(); // This will also update `isempty`
      } else if (result is DataFailed) {
        state = state.copyWith(
          isLoading: false,
          error: AppFailure.fromDio(result.error!),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error:
            e is DioException
                ? AppFailure.fromDio(e)
                : const AppFailure(message: 'Unexpected error'),
      );
    }
  }

  Future<bool> loadMore() async {
    if (state.isLoadingMore || state.isFinished) return true;
    state = state.copyWith(isLoadingMore: true);

    await Future.delayed(const Duration(milliseconds: 800));
    _page++;
    dbug('Load more products for page $_page');
    _applyFilters();

    return false;
  }


  ///  Recommendation: I should  use Filtering Usecase for query and sorting
  ///  Due to time constraints, I am using a utility function
  ///  to filter and sort the data in memory.
  ///  This is not efficient for large datasets and should be replaced
  void _applyFilters() {
    var filtered = ProductFilterUtils.search(_allProducts, _currentQuery);
    var sorted = ProductFilterUtils.sort(filtered, _currentSort);
    var paginated = sorted.take(_page * _pageSize).toList();

    state = state.copyWith(
      products: paginated,
      isLoading: false,
      isRefreshing: false,
      isLoadingMore: false,
      isempty: paginated.isEmpty,
      isFinished: paginated.length >= sorted.length,
      // Only clear error if we have products to show
      error: paginated.isNotEmpty ? null : state.error,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(
      isRefreshing: true,
      isLoading: false,
      isLoadingMore: false,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    _page = 0;
    _allProducts.clear();

    await fetchInitialProducts(); // This handles filters too

    _applyFilters();
  }

  void search(String query) {
    _currentQuery = query;
    state = state.copyWith(error: null);
    _applyFilters();
  }

  void sort(SortOrder order) {
    _currentSort = order;
    state = state.copyWith(error: null);
    _applyFilters();
  }

  void clearFilters() {
    _currentQuery = '';
    _currentSort = SortOrder.idAsc;
    _applyFilters();
  }
}
