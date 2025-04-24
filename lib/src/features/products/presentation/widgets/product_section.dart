
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:load_more_pagination/load_more_pagination.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_grid.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

class BuildProductSection extends StatelessWidget {
  const BuildProductSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.px,
      child: Consumer(
        builder: (_, ref, __) {
          final state = ref.watch(productProvider);
          final notifier = ref.read(productProvider.notifier);

          if (state.error != null) {
            return _ErrorSection(
              message: state.error?.message ?? 'An error occurred',
              onRetry: notifier.fetchInitialProducts,
            );
          }

          if (state.isLoading && state.products.isEmpty) {
            return ProductGrid(products: state.products, isLoading: true);
          }

          if (state.products.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(),
                const Center(child: Text('Refreshing new products')),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: LoadMorePagination(
              isFinish: state.isFinished,
              onLoadMorePagination: notifier.loadMore,
              loaderColor: Colors.green,
              whenEmptyLoad: true,
              delegate: const DefaultLoadMorePaginationDelegate(),
              textBuilder: DefaultLoadMorePaginationTextBuilder.english,
              child: 
              // Grid isn't working as expected. 
              // Listview woriking fine.
              // should be fixed in the future.
              ProductGrid(products: state.products),

              // ListView.builder(
              //   physics: const AlwaysScrollableScrollPhysics(),
              //   itemCount: state.products.length,
              //   itemBuilder: (context, index) {
              //     final product = state.products[index];
              //     return ListTile(
              //       leading: Text(product.id.toString()),
              //       title: Text(product.title),
              //       subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              //     );
              //   },
              // ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorSection({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
