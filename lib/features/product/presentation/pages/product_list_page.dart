import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product_entity.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/add_edit_product_modal.dart';
import '../widgets/product_card.dart';
import '../widgets/searchbar.dart';
import '../widgets/sidebar.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  String? _categoryFilter;
  String? _stockFilter;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  void _showAddEditProductModal({ProductEntity? product}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ProductBloc>(context),
        child: AddEditProductModal(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
          } else if (state is ProductAdded || state is ProductUpdated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(child: Text('Product saved successfully!')),
                    ],
                  ),
                  backgroundColor: Colors.green.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
          }
        },
        child: Row(
          children: [
            // Sidebar
            const Sidebar(),
            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Products',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage your product catalog',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        FloatingActionButton.extended(
                          onPressed: () => _showAddEditProductModal(),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Product'),
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search and Filters
                    _buildSearchAndFilters(),
                    const SizedBox(height: 24),

                    // Products Grid
                    Expanded(child: _buildProductsGrid()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Product Dashboard',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        SearchBarWidget(
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is! ProductLoaded) return const SizedBox.shrink();

        final categories = state.products.map((p) => p.category).toSet().toList();

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                              : null,
                        ),
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 160,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text('Category'),
                          ),
                          value: _categoryFilter,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All')),
                            ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                          ],
                          onChanged: (value) => setState(() => _categoryFilter = value),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text('Stock'),
                          ),
                          value: _stockFilter,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('All')),
                            DropdownMenuItem(value: 'In Stock', child: Text('In Stock')),
                            DropdownMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
                          ],
                          onChanged: (value) => setState(() => _stockFilter = value),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats Row
            _buildStatsRow(state.products),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow(List<ProductEntity> products) {
    final totalProducts = products.length;
    final inStock = products.where((p) => p.stock > 0).length;
    final categories = products.map((p) => p.category).toSet().length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.inventory_2_outlined,
            label: 'Total Products',
            value: totalProducts.toString(),
            color: Colors.blue.shade400,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            label: 'In Stock',
            value: '$inStock',
            color: Colors.green.shade400,
            suffix: Text('${(inStock / totalProducts * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.category_outlined,
            label: 'Categories',
            value: categories.toString(),
            color: Colors.purple.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    Widget? suffix,
  }) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(height: 4),
              suffix,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading products...'),
              ],
            ),
          );
        }

        if (state is ProductLoaded) {
          final filteredProducts = state.products.where((product) {
            final matchesSearch = product.title.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesCategory = _categoryFilter == null || product.category == _categoryFilter;
            final matchesStock = _stockFilter == null ||
                (_stockFilter == 'In Stock' && product.stock > 0) ||
                (_stockFilter == 'Out of Stock' && product.stock == 0);
            return matchesSearch && matchesCategory && matchesStock;
          }).toList();

          if (filteredProducts.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: filteredProducts[index],
                onTap: () => context.go('/products/${filteredProducts[index].id}'),
                onEdit: () => _showAddEditProductModal(product: filteredProducts[index]),
              );
            },
          );
        }

        if (state is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(state.message, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<ProductBloc>().add(FetchProducts()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first product',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddEditProductModal(),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}