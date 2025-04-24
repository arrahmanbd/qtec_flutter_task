import 'package:qtec_flutter_task/src/core/resources/data_state.dart';

import '../entities/product.dart';

abstract class ProductRepository {
  Future<DataState<List<Product>>> getProducts();
}
