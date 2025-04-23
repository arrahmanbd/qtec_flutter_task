import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_grid.dart';

class ProductLayout extends ConsumerWidget {
  const ProductLayout({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final notifier = ref.read(productProvider.notifier);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: 45.mt,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: notifier.search,
          ),
        ),

        Expanded(
          child:
              productState is ProductLoaded
                  ? ProductGrid(products: productState.products)
                  : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
