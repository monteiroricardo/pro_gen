import 'package:pro_gen/app/models/product_model.dart';
import 'package:pro_gen/app/repositories/mock_repository.dart';

class MockService {
  final _mockRepository = MockRepository();

  Future<void> createProduct(ProductModel product) =>
      _mockRepository.createProduct(product);

  Future<void> updateProduct(ProductModel product) =>
      _mockRepository.updateProduct(product);

  Future<void> deleteProduct(int productId) =>
      _mockRepository.deleteProduct(productId);

  Future<List<ProductModel>> readProducts() => _mockRepository.readProducts();

  Future<List<ProductModel>> searchProducts(String search) =>
      _mockRepository.searchProducts(search);
}
