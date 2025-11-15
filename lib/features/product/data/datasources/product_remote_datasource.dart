import '../../../../core/network/dio_client.dart';
import '../model/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> addProduct(Map<String, dynamic> productData);
  Future<ProductModel> updateProduct(int id, Map<String, dynamic> productData);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;
  ProductRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dioClient.get('/products');
    final products = (response.data['products'] as List)
        .map((product) => ProductModel.fromJson(product))
        .toList();
    return products;
  }

  @override
  Future<ProductModel> addProduct(Map<String, dynamic> productData) async {
    final response = await dioClient.post('/products/add', data: productData);
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<ProductModel> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await dioClient.put('/products/$id', data: productData);
    return ProductModel.fromJson(response.data);
  }
}