import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

// ---------- ADD THESE ----------
class ProductAdded extends ProductState {
  final ProductEntity addedProduct;
  const ProductAdded(this.addedProduct);

  @override
  List<Object?> get props => [addedProduct];
}

class ProductUpdated extends ProductState {
  final ProductEntity updatedProduct;
  const ProductUpdated(this.updatedProduct);

  @override
  List<Object?> get props => [updatedProduct];
}
// --------------------------------

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}