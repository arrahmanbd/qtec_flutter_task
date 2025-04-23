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
      body: Padding(
        padding: 16.px,
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final notifier = ref.read(productProvider.notifier);
                return CustomSearchField(
                  icon: 'assets/svgs/back.svg',
                  type: TextInputType.text,
                  hintText: 'Search Anything...',
                  onChanged: notifier.search,
                  autofocus: true,
                  showTrailing: true,
                  onLeading: () {
                    notifier.clearSearch();
                    notifier.resetFilters();
                    // Close the search page
                    Navigator.of(context).pop();
                  },
                  onTrailing: () {
                    _showSortBySheet(context);
                  },
                );
              },
            ),

            Consumer(
              builder: (_, WidgetRef ref, __) {
                final productState = ref.watch(productProvider);
                return Expanded(
                  child:
                      productState is ProductLoaded
                          ? ProductGrid(products: productState.products)
                          : const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showSortBySheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: 24.py,
          height: 317.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary
                  ),
                ),
                trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
              ),
             
              16.s,
              Expanded(
                child: Consumer(
                  builder: (_, WidgetRef ref, __) {
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
