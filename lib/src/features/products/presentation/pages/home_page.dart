import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:qtec_flutter_task/src/core/components/search_field.dart';

import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_section.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSearchBar(context),

          Expanded(child: BuildProductSection()),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return CustomSearchField(
      icon: 'assets/svgs/search-normal.svg',
      type: TextInputType.text,
      hintText: 'Search Anything...',
      disable: true,
      onDisable: () {
        if (!context.mounted) return;
        context.to(const SearchPage());
      },
      bottomMargin: 8.h,
    );
  }
}
