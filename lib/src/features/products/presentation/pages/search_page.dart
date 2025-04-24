import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/components/circle_icon.dart';
import 'package:qtec_flutter_task/src/core/components/search_field.dart';
import 'package:qtec_flutter_task/src/core/resources/assets_link.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_section.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';
import 'package:qtec_flutter_task/src/shared/utils/product_filter_utils.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(productProvider.notifier);
    return PopScope(
      onPopInvokedWithResult: (x, y) {
        notifier.clearFilters();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildResultCount(),
              Expanded(child: BuildProductSection()),
            ],
          ),
        ),
      ),
    );
  }

  // ⚠️ UX Warning: This search screen has no back button or navigation control.
  // If the user lands here without navigating through the app flow (e.g., deep link or initial route),
  // there's no intuitive way to go back. Consider adding an AppBar with a BackButton
  // or a navigation control to improve user experience.
  // ✅ Improved UX: Replaced the search icon with a back icon to give users a clear way to exit the search screen.
  // This avoids dead ends in navigation and aligns better with expected mobile behavior.

  Widget _buildSearchBar(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(productProvider.notifier);

        return CustomSearchField(
          icon: Assets.back,
          type: TextInputType.text,
          hintText: 'Search Anything...',
          onChanged: notifier.search,
          autofocus: true,
          showTrailing: true,
          bottomMargin: 8.h,
          onLeading: () {
            notifier.clearFilters();
            Navigator.of(context).pop();
          },
          onTrailing: () => _showSortBySheet(context),
        );
      },
    );
  }

  Widget _buildResultCount() {
    return Consumer(
      builder: (context, ref, _) {
        final productCount = ref.watch(productProvider).products.length;
        return Container(
          color: AppColors.cardColor,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          width: double.infinity,
          child: Center(
            child: Text(
              '$productCount Items found',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showSortBySheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.zero),
    ),
    builder: (_) => const _SortBySheetContent(),
  );
}

class _SortBySheetContent extends StatelessWidget {
  const _SortBySheetContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ).copyWith(top: 24.h, bottom: 16.h),
            child: _SortHeader(),
          ),
          const Expanded(child: _SortOptions()),
        ],
      ),
    );
  }
}

class _SortHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sort by',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        CircularIconButton(
          iconPath: Assets.cross,
          iconSize: 24,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _SortOptions extends StatelessWidget {
  const _SortOptions();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(productProvider.notifier);

        return ListView(
          children: [
            _SortOptionTile(
              label: 'Price - High to Low',
              onTap: () => notifier.sort(SortOrder.priceHighToLow),
            ),
            _SortOptionTile(
              label: 'Price - Low to High',
              onTap: () => notifier.sort(SortOrder.priceLowToHigh),
            ),
            _SortOptionTile(
              label: 'Name - A-Z',
              onTap: () => notifier.sort(SortOrder.nameAZ),
            ),
            _SortOptionTile(
              label: 'Name - Z-A',
              onTap: () => notifier.sort(SortOrder.nameZA),
            ),
            _SortOptionTile(
              label: 'Reset',
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortOptionTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(label), onTap: onTap);
  }
}
