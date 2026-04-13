import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/product_card.dart';
import '../../widgets/shimmer_widgets.dart';
import '../../widgets/animations.dart';
import '../product/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final productController = context.watch<ProductController>();
    final userName =
        authController.currentUser?.name.split(' ').first ?? 'Guest';
    final isLoading = productController.isLoading;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInWidget(
                    delay: const Duration(milliseconds: 0),
                    child: Text(
                      'Hello $userName,',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 80),
                    child: Text(
                      'Discover New\nFashion Trends',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Banner ───────────────────────────────────────
                  FadeInWidget(
                    delay: const Duration(milliseconds: 160),
                    child: isLoading
                        ? const BannerSkeleton()
                        : Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&q=80&w=1000',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.bottomLeft,
                              child: const Text(
                                'Autumn\nCollection 2026',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 32),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 240),
                    child: Text(
                      'Featured Products',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Product Grid / Skeleton ───────────────────────────────
          if (isLoading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 500,
                child: ProductGridSkeleton(count: 4),
              ),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final items = productController.products.length > 4
                        ? productController.products.sublist(0, 4)
                        : productController.products;
                    final product = items[index];
                    return StaggeredItem(
                      index: index,
                      child: ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            AppPageRoute(
                              child: ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: productController.products.length > 4
                      ? 4
                      : productController.products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
