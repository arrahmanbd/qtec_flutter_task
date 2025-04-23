import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/components/search_field.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_grid.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';
import 'package:qtec_flutter_task/src/shared/utils/sort_order.dart';
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildResultCount(),
            Expanded(child: _buildProductContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(productProvider.notifier);

        return CustomSearchField(
          icon: 'assets/svgs/back.svg',
          type: TextInputType.text,
          hintText: 'Search Anything...',
          onChanged: notifier.search,
          autofocus: true,
          showTrailing: true,
          bottomMargin: 8.h,
          onLeading: () {
            notifier.clearSearch();
            notifier.resetFilters();
            Navigator.of(context).pop();
          },
          onTrailing: () => _showSortBySheet(context),
        );
      },
    );
  }

  Widget _buildResultCount() {
    return Consumer(
      builder: (context, ref, _) {
        final productCount = ref.watch(productProvider).products.length;
        return Container(
          color: AppColors.cardColor,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          width: double.infinity,
          child: Center(
            child: Text(
              '$productCount Items found',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(productProvider);

          if (state is ProductError) {
            return Center(
              child: Text(
                state.error?.message ?? 'An error occurred',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            );
          }

          if (state is ProductLoading) {
            return ProductGrid(products: state.products, isLoading: true);
          }

          if (state is ProductLoaded) {
            return ProductGrid(products: state.products);
          }

          return const Center(child: Text('No products found'));
        },
      ),
    );
  }

  Future<void> _showSortBySheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSortHeader(context),
              SizedBox(height: 16.h),
              Expanded(child: _buildSortOptions()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sort by',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(productProvider.notifier);

        return ListView(
          children: [
            ListTile(
              title: const Text('Price - High to Low'),
              onTap: () => notifier.sort(SortOrder.highToLow),
            ),
            ListTile(
              title: const Text('Price - Low to High'),
              onTap: () => notifier.sort(SortOrder.lowToHigh),
            ),
            ListTile(
              title: const Text('Reset'),
              onTap: () {
                notifier.resetFilters();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
