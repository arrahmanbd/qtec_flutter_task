import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/riverpod/product_provider.dart';
import 'package:qtec_flutter_task/src/features/products/presentation/widgets/product_layout.dart';
import 'package:qtec_flutter_task/src/shared/utils/sort_order.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ProductLayout(),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () {
              // ref.read(productProvider.notifier).fetchProducts();
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sort by',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final notifier = ref.read(productProvider.notifier);
                            return Column(
                              children: [
                                TextButton(
                                  onPressed:
                                      () => notifier.sort(SortOrder.lowToHigh),
                                  child: const Text('Price: Low to High'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => notifier.sort(SortOrder.highToLow),
                                  child: const Text('Price: High to Low'),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }
}
