// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:qtec_flutter_task/src/core/components/circle_icon.dart';
import 'package:qtec_flutter_task/src/features/products/data/models/product_model.dart';

import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  const ProductGrid({
    super.key,
    required this.products,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.h), // included 8 on header
        itemCount: isLoading ? 10 : products.length,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 264.h,
          mainAxisSpacing: 24.h,
          crossAxisSpacing: 16.w,
        ),
        itemBuilder: (context, index) {
          final product = isLoading ? ProductModel.fake() : products[index];
          return _ProductCard(product: product);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isLoading = Skeletonizer.of(context).enabled;

    return Material(
      color: AppColors.backgroundColor,

      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            // Product Image
            SizedBox(
              width: 156.w,
              height: 164.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child:
                    isLoading
                        ? const SkeletonLoader(width: 156, height: 164)
                        : CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          width: 156.w,
                          height: 164.h,
                          placeholder:
                              (context, url) => Container(
                                color: AppColors.greyColor,
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: AppColors.greyColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                        ),
              ),
            ),

            // Product Title
            SizedBox(
              height: 36.h,
              child:
                  isLoading
                      ? const SkeletonLoader(width: 120, height: 8)
                      : Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall.copyWith(fontSize: 12.sp),
                      ),
            ),

            // Price and Discount
            isLoading
                ? const SkeletonLoader(width: 150, height: 8)
                : RichText(
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontSize: 14.sp),
                    children: [
                      TextSpan(
                        text: product.price.toDollar(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 14.sp,
                        ),
                      ),
                      WidgetSpan(child: 4.s),
                      TextSpan(
                        text: (product.price + 20).toDollar(),
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.greyColor,
                          decorationThickness: 1.5,
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                        ),
                      ),
                      WidgetSpan(child: 4.s),
                      TextSpan(
                        text: '25% OFF',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: const Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                ),

            // Rating Section
            isLoading
                ? const SkeletonLoader(width: 120, height: 10)
                : RichText(
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontSize: 14.sp),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text: '4.3 ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 12.sp,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text: '(646)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: AppColors.iconColor,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    ).stackWith(
      children: [
        Positioned(
          top: 4.h,
          child: Container(
            padding: EdgeInsets.only(right: 12.w, left: 4.w),
            width: 156.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                true && !isLoading
                    ? OutOfStockBadge()
                    : SkeletonLoader(width: 40, height: 8),
                CircularIconButton(
                  //icon: Icons.favorite_border,
                  iconPath: 'assets/svgs/heart.svg',
                  onPressed: () {
                    // Handle favorite action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added to favourite'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  iconSize: 16,
                  size: 24.sp,
                  backgroundColor: Colors.white,
                  iconColor: AppColors.iconColor,
                  elevation: 0,
                  padding: 0,
                  blur: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OutOfStockBadge extends StatelessWidget {
  const OutOfStockBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Text(
        'Out of Stock',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonLoader({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.greyColor,
      margin: 4.p,
    );
  }
}
