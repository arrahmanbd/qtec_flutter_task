import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_list.dart';

import '../riverpod/product_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qtech App')),
      body: ProductGridPage(),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
              onPressed: () {
               ref.read(productProvider.notifier).fetchProducts();
              // ref.read(productProvider.notifier).fetchProducts();
              },
              child: const Icon(Icons.refresh),
            );
        },
      ),
    );
  }
}
