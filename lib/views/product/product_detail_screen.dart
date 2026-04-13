import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/animations.dart';
import '../../widgets/product_card.dart';
import '../../core/theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _added = false;
  String? _selectedSize;
  Color? _selectedColor;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> _colors = [
    Colors.black,
    const Color(0xFFD6A054), // Gold
    Colors.grey,
    const Color(0xFF4A235A), // Purple
  ];

  void _addToCart() {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a size')),
      );
      return;
    }
    context.read<CartController>().addItem(widget.product.id);
    setState(() => _added = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'VIEW',
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistController = context.watch<WishlistController>();
    final productController = context.read<ProductController>();
    final isFavorite = wishlistController.isInWishlist(widget.product.id);
    final relatedProducts = productController.products
        .where((p) => p.category == widget.product.category && p.id != widget.product.id)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${widget.product.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      wishlistController.toggleWishlist(widget.product);
                    },
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.category.toUpperCase(),
                    style: const TextStyle(letterSpacing: 1.5, color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.star, color: AppTheme.accentColor, size: 18),
                      SizedBox(width: 4),
                      Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Text('(124 Reviews)', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('Select Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: _sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = size),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                            border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            size,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  const Text('Select Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: _colors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: AppTheme.accentColor, width: 3) : null,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),

                  const SizedBox(height: 32),
                  const Text('Customer Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _ReviewItem(
                    name: 'Michael Smith',
                    rating: 5,
                    comment: 'Absolutely stunning! The quality of the fabric is even better than expected.',
                    date: '2 weeks ago',
                  ),
                  _ReviewItem(
                    name: 'Sarah Wilson',
                    rating: 4,
                    comment: 'Beautiful dress, but it runs a bit large. Consider sizing down.',
                    date: '1 month ago',
                  ),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Related Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text('View All')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 150,
                            child: ProductCard(
                              product: relatedProducts[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  AppPageRoute(child: ProductDetailScreen(product: relatedProducts[index])),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _added
                ? Container(
                    key: const ValueKey('done'),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('ADDED TO CART', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          key: const ValueKey('add'),
                          text: 'ADD TO CART',
                          onPressed: _addToCart,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String date;

  const _ReviewItem({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: AppTheme.accentColor,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}
