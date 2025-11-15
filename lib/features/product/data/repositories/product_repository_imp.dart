import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<ProductEntity> addProduct(Map<String, dynamic> productData) async {
    return await remoteDataSource.addProduct(productData);
  }

  @override
  Future<ProductEntity> updateProduct(int id, Map<String, dynamic> productData) async {
    return await remoteDataSource.updateProduct(id, productData);
  }
}