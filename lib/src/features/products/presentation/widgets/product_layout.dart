import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          Container(
            margin: 45.mt,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Anything...',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                prefixIcon: const Icon(Icons.search),
                hintStyle: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400
                ),
                border: _borderStyle(),
                focusedBorder: _borderStyle(),
                enabledBorder:_borderStyle()
                
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
      ),
    );
  }

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.outline,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
              );
  }
}
