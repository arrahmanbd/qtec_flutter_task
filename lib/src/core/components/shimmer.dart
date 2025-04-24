import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: 0.p, // included 8 on header
        itemCount: 10,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 264.h,
          mainAxisSpacing: 24.h,
          crossAxisSpacing: 16.w,
        ),
        itemBuilder: (context, index) {
          return ProductCardSkeleton();
        },
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Skeleton for product image
          SizedBox(
            width: 156.w,
            height: 164.h,
            child: const SkeletonLoader(width: 156, height: 164),
          ),

          // Skeleton for product title
          SizedBox(
            height: 36.h,
            child: const SkeletonLoader(width: 120, height: 8),
          ),

          // Skeleton for price and discount
          const SkeletonLoader(width: 150, height: 8),

          // Skeleton for rating section
          const SkeletonLoader(width: 120, height: 10),
        ],
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
