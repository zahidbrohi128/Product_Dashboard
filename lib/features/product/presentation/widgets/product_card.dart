import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
  });

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'beauty':
        return const Color(0xFFF59E0B);
      case 'fragrances':
        return const Color(0xFF10B981);
      case 'furniture':
        return const Color(0xFF3B82F6);
      case 'groceries':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInStock = product.stock > 0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Placeholder
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getProductIcon(product.category),
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(product.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.category[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: _getCategoryColor(product.category),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getCategoryColor(product.category),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF059669),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isInStock ? Colors.green.shade100 : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isInStock ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isInStock ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_outlined),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue.shade50,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              tooltip: 'Edit',
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: onTap,
                            icon: const Icon(Icons.visibility_outlined),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            tooltip: 'View Details',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getProductIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beauty':
        return Icons.face_retouching_natural_outlined;
      case 'fragrances':
        return Icons.local_florist_outlined;
      case 'furniture':
        return Icons.weekend_outlined;
      case 'groceries':
        return Icons.local_grocery_store_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}