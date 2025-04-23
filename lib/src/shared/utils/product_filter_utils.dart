
import 'package:qtec_flutter_task/src/shared/utils/sort_order.dart';

import '../../features/products/domain/entities/product.dart';

class ProductFilterUtils {
  static List<Product> search(List<Product> products, String query) {
    return products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<Product> sort(List<Product> products, SortOrder order) {
    final sorted = [...products];
    sorted.sort((a, b) =>
        order == SortOrder.lowToHigh ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    return sorted;
  }
}
