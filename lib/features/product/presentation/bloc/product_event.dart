import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Map<String, dynamic> productData;
  const AddProduct(this.productData);
}

class UpdateProduct extends ProductEvent {
  final ProductEntity product;
  const UpdateProduct(this.product);
}