// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:qtec_flutter_task/src/core/components/search_field.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/pages/search_page.dart';

import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_state.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_grid.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

class ProductLayout extends ConsumerWidget {
  const ProductLayout({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final notifier = ref.read(productProvider.notifier);
    return Padding(
      padding: 16.px,
      child: Column(
        children: [
          CustomSearchField(
            icon: 'assets/svgs/search-normal.svg',
            type: TextInputType.text,
            hintText: 'Search Anything...',
            // onChanged: notifier.search,
            disable: true,
            onDisable: () {
              // Perform any action when the field is disabled
              // For example, show a snackbar or alert
              context.to(SearchPage());
            },
          ),

          Expanded(
            child:
                productState is ProductLoaded
                    ? ProductGrid(products: productState.products)
                    : ProductGrid(products: productState.products, isLoading: true),),
          
        ],
      ),
    );
  }
}
