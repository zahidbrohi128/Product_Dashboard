import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> addProduct(Map<String, dynamic> productData);
  Future<ProductEntity> updateProduct(int id, Map<String, dynamic> productData);
}