import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/core/components/search_field.dart';

import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_section.dart';
import 'package:qtec_flutter_task/src/shared/global/connection_status.dart';
import 'search_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // global connection checker
    ref.listen<ConnectivityState>(connectionStateProvider, (previous, next) {
      if (next == ConnectivityState.disconnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('No internet connection.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (previous == ConnectivityState.disconnected &&
          next == ConnectivityState.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Internet connection restored.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
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
