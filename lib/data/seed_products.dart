import '../models/product_model.dart';

/// Five sample products for Firestore seeding (assignment demo).
List<ProductModel> get seedProducts => [
      ProductModel(
        id: 'seed_1',
        name: 'Elegant Evening Dress',
        description:
            'A stunning evening dress perfect for luxury events. Premium silk with hand-stitched detailing.',
        price: 299.99,
        category: 'Dresses',
        imageUrl:
            'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'seed_2',
        name: 'Designer Leather Bag',
        description:
            'Genuine leather handbag with gold-tone hardware and spacious interior compartments.',
        price: 159.50,
        category: 'Bags',
        imageUrl:
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'seed_3',
        name: 'Classic Stilettos',
        description:
            'Black velvet stilettos for a timeless look. Cushioned insoles for all-day comfort.',
        price: 120.00,
        category: 'Shoes',
        imageUrl:
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'seed_4',
        name: 'Gold Plated Necklace',
        description:
            'Minimalist 18k gold plated necklace. Hypoallergenic and tarnish-resistant.',
        price: 85.00,
        category: 'Accessories',
        imageUrl:
            'https://images.unsplash.com/photo-1611085583191-a3b181a88401?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'seed_5',
        name: 'Slim Fit Blazer',
        description:
            'Tailored slim fit blazer in charcoal grey. Perfect for formal occasions.',
        price: 245.00,
        category: 'Men',
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=800',
      ),
    ];
