// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:qtec_flutter_task/src/core/components/circle_icon.dart';

import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // demonestrated  the favorite button
    // and out of stock badge
    final fav = [1, 4, 5].contains(product.id);
    final outOfStock = [4, 11, 15].contains(product.id);
    return Stack(
      children: [
        _buildBaseCard(context),
        Positioned(
          top: 8.h,
          child: Container(
            padding: EdgeInsets.only(right: 12.w, left: 4.w),
            width: 156.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                outOfStock ? const OutOfStockBadge() : const SizedBox(),
                CircularIconButton(
                  iconPath:
                      fav
                          ? 'assets/svgs/heart_filled.svg'
                          : 'assets/svgs/heart.svg',
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
                  backgroundColor: AppColors.backgroundColor.withValues(
                    alpha: 0.7,
                  ),
                  //iconColor: AppColors.red,
                  elevation: 0,
                  padding: 0,
                  // Disabled blur for performance optimization
                  // I found that the blur effect was not necessary for this design
                  // and it was causing performance issues on lower-end devices.
                  // If you want to keep the blur effect, you can set it to true
                  blur: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Card _buildBaseCard(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 156.w,
            height: 164.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                width: 156.w,
                height: 164.h,
                placeholder:
                    (context, url) => Container(
                      color: AppColors.greyColor,
                      // child: const Center(child: CupertinoActivityIndicator()),
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
          8.s,
          SizedBox(
            height: 36.h,
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall.copyWith(fontSize: 12.sp),
            ),
          ),
          RichText(
            overflow: TextOverflow.ellipsis,
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
          8.s,
          RichText(
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
    );
  }
}

class OutOfStockBadge extends StatelessWidget {
  const OutOfStockBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4.w),
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
