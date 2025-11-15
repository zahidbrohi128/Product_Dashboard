import 'package:go_router/go_router.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListPage(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return ProductDetailPage(productId: id);
      },
    ),
  ],
);