import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';

class AddEditProductModal extends StatefulWidget {
  final ProductEntity? product;

  const AddEditProductModal({super.key, this.product});

  @override
  State<AddEditProductModal> createState() => _AddEditProductModalState();
}

class _AddEditProductModalState extends State<AddEditProductModal>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String? _selectedCategory;

  final List<String> _categories = [
    'Beauty',
    'Fragrances',
    'Furniture',
    'Groceries',
    'Electronics',
    'Clothing',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _selectedCategory = widget.product?.category;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.product != null;

      if (isEditing) {
        final updatedProduct = ProductEntity(
          id: widget.product!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          category: _selectedCategory ?? _categoryController.text,
          brand: widget.product!.brand,
          discountPercentage: widget.product!.discountPercentage,
          images: widget.product!.images,
          rating: widget.product!.rating,
          thumbnail: widget.product!.thumbnail,
        );
        context.read<ProductBloc>().add(UpdateProduct(updatedProduct));
      } else {
        final productData = {
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'stock': int.parse(_stockController.text),
          'description': _descriptionController.text,
          'category': _selectedCategory ?? _categoryController.text,
        };
        context.read<ProductBloc>().add(AddProduct(productData));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final title = isEditing ? 'Edit Product' : 'Add New Product';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1),
                      const Color(0xFF8B5CF6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isEditing ? Icons.edit : Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _titleController,
                        label: 'Product Name',
                        icon: Icons.inventory_2_outlined,
                        validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryField(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceController,
                              label: 'Price (\$)',
                              icon: Icons.attach_money_outlined,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter a price';
                                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                  return 'Please enter a valid price';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _stockController,
                              label: 'Stock',
                              icon: Icons.production_quantity_limits_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter stock quantity';
                                if (int.tryParse(value) == null || int.parse(value) < 0) {
                                  return 'Please enter a valid stock quantity';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(category[0].toUpperCase() + category.substring(1)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select a category' : null,
          ),
        ),
      ],
    );
  }
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
      case 'electronics':
        return const Color(0xFF8B5CF6);
      case 'clothing':
        return const Color(0xFF06B6D4);
      default:
        return Colors.grey;
    }
  }
}