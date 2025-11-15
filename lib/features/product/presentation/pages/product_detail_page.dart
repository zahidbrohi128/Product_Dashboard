import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Import the ProductModel to use in the orElse clause
import '../../data/model/product_model.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_state.dart';
import '../widgets/add_edit_product_modal.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  void _showAddEditProductModal(BuildContext context, {ProductEntity? product}) {
    showDialog(
      context: context,
      builder: (context) {
        return AddEditProductModal(product: product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/products'),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            final product = state.products.firstWhere(
                  (p) => p.id == productId,
              // FIX: Change ProductEntity to ProductModel here
              orElse: () => const ProductModel(
                id: 0,
                title: 'Not Found',
                description: '',
                price: 0,
                discountPercentage: 0,
                rating: 0,
                stock: 0,
                brand: '',
                category: '',
                thumbnail: '',
                images: [],
              ),
            );

            if (product.id == 0) {
              return const Center(child: Text('Product not found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      ...product.images.map((url) => Image.network(url, width: 150, height: 150, fit: BoxFit.cover)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailRow('Price:', '\$${product.price.toStringAsFixed(2)}'),
                  _buildDetailRow('Stock:', '${product.stock} units (${product.stock > 0 ? 'In Stock' : 'Out of Stock'})'),
                  _buildDetailRow('Category:', product.category),
                  _buildDetailRow('Brand:', product.brand),
                  _buildDetailRow('Rating:', '${product.rating} / 5.0'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditProductModal(context, product: product),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Product'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}