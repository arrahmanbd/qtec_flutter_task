

import '../../features/products/domain/entities/product.dart';

enum SortOrder {
  priceLowToHigh,
  priceHighToLow,
  nameAZ,
  nameZA,
  idAsc,
  idDesc,
}


class ProductFilterUtils {
  static List<Product> search(List<Product> products, String query) {
    return products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<Product> sort(List<Product> products, SortOrder order) {
  final sorted = [...products];
  sorted.sort((a, b) {
    switch (order) {
      case SortOrder.priceLowToHigh:
        return a.price.compareTo(b.price);
      case SortOrder.priceHighToLow:
        return b.price.compareTo(a.price);
      case SortOrder.nameAZ:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case SortOrder.nameZA:
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      case SortOrder.idAsc:
        return a.id.compareTo(b.id);
      case SortOrder.idDesc:
        return b.id.compareTo(a.id);
    }
  });
  return sorted;
}


}
