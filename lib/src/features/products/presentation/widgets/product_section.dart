import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/components/shimmer.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_card.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

class ProductGridPage extends ConsumerStatefulWidget {
  const ProductGridPage({super.key});

  @override
  ConsumerState<ProductGridPage> createState() => _ProductGridPageState();
}

class _ProductGridPageState extends ConsumerState<ProductGridPage> {
  final ScrollController _scrollController = ScrollController();

  void _setupScrollListener() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        await ref.read(productProvider.notifier).loadMore();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(productProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: 8.py,
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= state.products.length) {
                    return Center();
                  }

                  final product = state.products[index];
                  return ProductCardWidget(product: product);
                },
                childCount:
                    state.products.length + (state.isLoadingMore ? 1 : 0),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .58,
                mainAxisExtent: 264.h,
                mainAxisSpacing: 24.h,
                crossAxisSpacing: 16.w,
              ),
            ),
          ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CupertinoActivityIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class BuildProductSection extends StatelessWidget {
  const BuildProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.px,
      child: Consumer(
        builder: (_, ref, __) {
          final state = ref.watch(productProvider);
          final notifier = ref.read(productProvider.notifier);

          final isLoading = state.isLoading || state.isRefreshing;
          final isEmptySearch = state.products.isEmpty && notifier.isSearching;
          final isEmptyData = state.products.isEmpty && !notifier.isSearching;
          final hasError = state.error != null && !state.isRefreshing;

          // 1. Loading shimmer on first load or refresh
          if (isLoading && state.products.isEmpty) {
            return const Shimmer();
          }

          // 2. Show error only if not searching, no data, and error exists
          if (hasError && isEmptyData) {
            return _ErrorSection(
              message: state.error?.message ?? 'An error occurred',
              onRetry: notifier.refresh,
            );
          }

          // 3. Show "No item found" if search yields no result (but no error)
          if (isEmptySearch && !hasError) {
            return const Center(child: Text('No item found'));
          }

          // 4. Show products
          return const ProductGridPage();
        },
      ),
    );
  }
}

class _ErrorSection extends ConsumerWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorSection({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onPressed: () {
              ref.read(productProvider.notifier).refresh();
            },
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
