
import 'package:qtec_flutter_task/src/core/usecase/base_usecase.dart';
import 'package:qtec_flutter_task/src/features/products/domain/entities/product.dart';
import 'package:qtec_flutter_task/src/features/products/domain/repository/produtc_repository.dart';

class GetProductUsecase implements UseCase<List<Product>, void> {
  final ProductRepository productRepository;
  GetProductUsecase(this.productRepository);
  @override
  Future<List<Product>> call({params}) {
    return productRepository.getProducts();
  }
}