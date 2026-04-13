import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/wishlist_controller.dart';
import '../../widgets/product_card.dart';
import '../../widgets/animations.dart';
import '../product/product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = context.watch<WishlistController>();
    final items = wishlistController.wishlistItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Your wishlist is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(24.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return StaggeredItem(
                  index: index,
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        AppPageRoute(child: ProductDetailScreen(product: product)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
