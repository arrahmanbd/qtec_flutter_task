import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: 0.p,
      itemCount: products.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 264.h,
        mainAxisSpacing: 24.h,
        crossAxisSpacing: 16.w,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Container(
                color: AppColors.greyColor,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  width: 156.w,
                  height: 164.h,
                ),
              ),
              ),
            ),
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
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontSize: 14.sp),
                children: [
                  TextSpan(
                    text: product.price.toDollar(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                      fontSize: 14.sp,
                    ),
                  ),
                 WidgetSpan(child:4.s),
                  TextSpan(
                    text: (product.price + 20).toDollar(),
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
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
            RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontSize: 14.sp),
                children: [
                  WidgetSpan(
                    child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.star, size: 16, color: Colors.white),
                    ),
                  ),
                   const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(
                    text: '4.3 ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
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
            )
          ],
        ),
      ),
    );
  }
}
