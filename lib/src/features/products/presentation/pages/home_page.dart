import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/components/search_field.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_grid.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 16),
            Expanded(child: _buildProductSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return CustomSearchField(
      icon: 'assets/svgs/search-normal.svg',
      type: TextInputType.text,
      hintText: 'Search Anything...',
      disable: true,
      onDisable: () {
        if (!context.mounted) return;
        context.to(const SearchPage());
      },
    );
  }

  Widget _buildProductSection() {
    return Padding(
      padding: 16.px,
      child: Consumer(
        builder: (_, WidgetRef ref, __) {
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
            return ProductGrid(products:state.products, isLoading: true);
          }

          if (state is ProductLoaded) {
            return ProductGrid(products: state.products, isLoading: true);
          }

          return const Center(child: Text('No products found'));
        },
      ),
    );
  }
}
