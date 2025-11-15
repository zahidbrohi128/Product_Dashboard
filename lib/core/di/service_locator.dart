import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../features/product/data/datasources/product_remote_datasource.dart';
import '../../features/product/data/repositories/product_repository_imp.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecase/add_product_usecase.dart';
import '../../features/product/domain/usecase/get_product_usecase.dart';
import '../../features/product/domain/usecase/update_product_usecase.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void setupLocator() {
  // BLoC
  sl.registerFactory(() => ProductBloc(
    getProductsUseCase: sl(),
    addProductUseCase: sl(),
    updateProductUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(remoteDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
          () => ProductRemoteDataSourceImpl(dioClient: sl()));

  // Core
  sl.registerLazySingleton(() => DioClient(Dio()));
}