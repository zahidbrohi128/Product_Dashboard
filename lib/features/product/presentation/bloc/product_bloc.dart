import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/product_model.dart'; // Import ProductModel
import '../../domain/usecase/add_product_usecase.dart';
import '../../domain/usecase/get_product_usecase.dart';
import '../../domain/usecase/update_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
  }) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
  }

  void _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await getProductsUseCase();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Failed to fetch products: ${e.toString()}"));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      try {
        final newProduct = await addProductUseCase(event.productData);
        // Add the new product to the existing list
        final updatedList = [...currentState.products, newProduct];
        emit(ProductLoaded(updatedList));
      } catch (e) {
        // Emit an error state but keep the old data
        emit(ProductError("Failed to add product: ${e.toString()}"));
        emit(currentState); // Re-emit the old state so the list doesn't disappear
      }
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      try {
        // FIX: Convert the ProductEntity to a ProductModel, then to JSON
        final productModel = ProductModel.fromEntity(event.product);
        final updatedProduct = await updateProductUseCase(event.product.id, productModel.toJson());

        // Find and replace the updated product in the list
        final updatedList = currentState.products.map((p) {
          return p.id == updatedProduct.id ? updatedProduct : p;
        }).toList();

        emit(ProductLoaded(updatedList));
      } catch (e) {
        emit(ProductError("Failed to update product: ${e.toString()}"));
        emit(currentState);
      }
    }
  }
}