// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
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
        padding: 0.p,
        itemCount: isLoading ? 10 : products.length,
        physics: const BouncingScrollPhysics(),
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
      borderRadius: BorderRadius.circular(12.r),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      ? const SkeletonLoader(width: 120, height: 16)
                      : Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall.copyWith(fontSize: 12.sp),
                      ),
            ),

            // Price and Discount
            isLoading
                ? const SkeletonLoader(width: 150, height: 16)
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
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

            // Rating Section
            isLoading
                ? const SkeletonLoader(width: 120, height: 16)
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
                            color: AppColors.primaryColor,
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
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
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
