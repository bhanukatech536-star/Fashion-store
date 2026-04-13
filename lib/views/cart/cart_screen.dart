import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/shimmer_widgets.dart';
import '../../widgets/animations.dart';
import 'checkout_screen.dart';
import '../../core/theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final productController = context.read<ProductController>();
    final isLoading = context.watch<ProductController>().isLoading;
    final cartItems = cartController.items.values.toList();

    double calculateTotal() {
      double total = 0;
      for (var item in cartItems) {
        try {
          final product = productController.getProductById(item.productId);
          total += product.price * item.quantity;
        } catch (_) {}
      }
      return total;
    }

    final totalPrice = calculateTotal();

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Cart',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Playfair Display',
                ),
              ),
            ),
          ),

          // Show shimmer while products are still loading
          if (isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (_, __) => const CartItemSkeleton(),
              ),
            )
          else if (cartItems.isEmpty)
            Expanded(
              child: FadeInWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  final product =
                      productController.getProductById(cartItem.productId);

                  return StaggeredItem(
                    index: index,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: Colors.grey.shade100,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _QtyButton(
                                      icon: Icons.remove,
                                      onTap: () =>
                                          cartController.updateQuantity(
                                              cartItem.productId,
                                              cartItem.quantity - 1),
                                    ),
                                    const SizedBox(width: 12),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(
                                              scale: anim, child: child),
                                      child: Text(
                                        '${cartItem.quantity}',
                                        key: ValueKey(cartItem.quantity),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _QtyButton(
                                      icon: Icons.add,
                                      onTap: () =>
                                          cartController.updateQuantity(
                                              cartItem.productId,
                                              cartItem.quantity + 1),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.grey),
                                      onPressed: () =>
                                          cartController.removeItem(
                                              cartItem.productId),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // ── Checkout Bar ─────────────────────────────────────────────
          if (!isLoading && cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style:
                                TextStyle(fontSize: 18, color: Colors.grey)),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                          child: Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            key: ValueKey(totalPrice),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'PROCEED TO CHECKOUT',
                      onPressed: () {
                        Navigator.push(
                          context,
                          AppPageRoute(
                            child: CheckoutScreen(totalPrice: totalPrice),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small +/- quantity button
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
