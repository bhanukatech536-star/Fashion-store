import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Men', 'Women', 'Dresses', 'Shoes', 'Accessories', 'Bags'];

  ProductController() {
    _initProducts();
  }

  Future<void> _initProducts() async {
    _isLoading = true;
    notifyListeners();
    // Simulated network delay — swap with Firestore fetch later
    await Future.delayed(const Duration(milliseconds: 1800));
    _loadMockProducts();
    _isLoading = false;
    notifyListeners();
  }

  void _loadMockProducts() {
    _products = [
      // ── Dresses ──────────────────────────────────────────────────
      ProductModel(
        id: 'p1',
        name: 'Elegant Evening Dress',
        description: 'A stunning evening dress perfect for luxury events. Made with premium silk and hand-stitched detailing.',
        price: 299.99,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p5',
        name: 'Summer Floral Dress',
        description: 'Light and airy floral dress, perfect for summer outings. Features a flattering A-line silhouette.',
        price: 145.00,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p7',
        name: 'Satin Midi Dress',
        description: 'Luxurious satin midi dress with a cowl neckline and delicate spaghetti straps. Perfect for cocktail parties.',
        price: 225.00,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p8',
        name: 'Bohemian Maxi Dress',
        description: 'Free-spirited boho maxi dress with intricate embroidery and flowing fabric. Ideal for festivals and beach days.',
        price: 175.00,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p9',
        name: 'Little Black Dress',
        description: 'The timeless LBD reimagined with modern tailoring, featuring a sculpted waist and knee-length hem.',
        price: 189.00,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?auto=format&fit=crop&q=80&w=800',
      ),

      // ── Shoes ────────────────────────────────────────────────────
      ProductModel(
        id: 'p3',
        name: 'Classic Stilettos',
        description: 'Black velvet stilettos for a timeless and sophisticated look. Features cushioned insoles for all-day comfort.',
        price: 120.00,
        category: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p10',
        name: 'Suede Ankle Boots',
        description: 'Premium suede ankle boots with a block heel and side zip closure. A versatile wardrobe essential.',
        price: 195.00,
        category: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p11',
        name: 'Designer Sneakers',
        description: 'Luxury leather sneakers with minimalist design and handcrafted Italian construction.',
        price: 265.00,
        category: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p12',
        name: 'Strappy Sandals',
        description: 'Elegant strappy sandals in metallic gold with a comfortable low heel. Perfect for summer evenings.',
        price: 98.00,
        category: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1603487742131-4160ec999306?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p13',
        name: 'Leather Loafers',
        description: 'Polished leather loafers with a modern chunky sole. Effortlessly bridges casual and formal.',
        price: 155.00,
        category: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&q=80&w=800',
      ),

      // ── Bags ─────────────────────────────────────────────────────
      ProductModel(
        id: 'p2',
        name: 'Designer Leather Bag',
        description: 'Genuine leather handbag with elegant gold-tone hardware and spacious interior compartments.',
        price: 159.50,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p6',
        name: 'Leather Crossbody',
        description: 'Compact crossbody bag with adjustable strap and premium full-grain leather construction.',
        price: 110.00,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p14',
        name: 'Canvas Tote Bag',
        description: 'Oversized canvas tote with leather handles and brass accents. Perfect for work or weekend errands.',
        price: 78.00,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p15',
        name: 'Quilted Chain Bag',
        description: 'Classic quilted leather bag with a polished chain strap. Inspired by timeless Parisian elegance.',
        price: 320.00,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p16',
        name: 'Woven Straw Clutch',
        description: 'Hand-woven straw clutch with a magnetic snap closure. A must-have for resort season.',
        price: 65.00,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1575032617751-6ddec2089882?auto=format&fit=crop&q=80&w=800',
      ),

      // ── Accessories ──────────────────────────────────────────────
      ProductModel(
        id: 'p4',
        name: 'Gold Plated Necklace',
        description: 'Minimalist 18k gold plated necklace with a subtle pendant. Hypoallergenic and tarnish-resistant.',
        price: 85.00,
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1611085583191-a3b181a88401?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p17',
        name: 'Silk Scarf',
        description: 'Hand-printed pure silk scarf with a vibrant abstract pattern. Can be styled as a headband or bag accent.',
        price: 95.00,
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1602173574767-37ac01994b2a?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p18',
        name: 'Oversized Sunglasses',
        description: 'Retro-inspired oversized sunglasses with UV400 polarized lenses and acetate frames.',
        price: 135.00,
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p19',
        name: 'Leather Watch',
        description: 'Swiss-movement watch with a genuine leather strap and rose-gold case. Water resistant to 50m.',
        price: 245.00,
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p20',
        name: 'Pearl Drop Earrings',
        description: 'Freshwater pearl drop earrings set in sterling silver. Elegant simplicity for any occasion.',
        price: 72.00,
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&q=80&w=800',
      ),
      // ── Men ───────────────────────────────────────────────────
      ProductModel(
        id: 'p21',
        name: 'Slim Fit Blazer',
        description: 'Tailored slim fit blazer in charcoal grey. Perfect for formal and semi-formal occasions.',
        price: 245.00,
        category: 'Men',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p22',
        name: 'Casual Denim Jacket',
        description: 'Classic wash denim jacket with brass button detailing. A timeless layering staple.',
        price: 135.00,
        category: 'Men',
        imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p23',
        name: 'Oxford Dress Shirt',
        description: 'Premium cotton Oxford shirt in crisp white with a button-down collar.',
        price: 89.00,
        category: 'Men',
        imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p24',
        name: 'Chino Trousers',
        description: 'Slim-cut chino trousers in khaki. Stretch cotton blend for all-day comfort.',
        price: 78.00,
        category: 'Men',
        imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p25',
        name: 'Leather Belt',
        description: 'Full-grain leather belt with a brushed silver buckle. Hand-stitched edges.',
        price: 55.00,
        category: 'Men',
        imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&q=80&w=800',
      ),

      // ── Women ─────────────────────────────────────────────────
      ProductModel(
        id: 'p26',
        name: 'Wrap Blouse',
        description: 'Elegant satin wrap blouse in blush pink. Flattering V-neckline with tie waist.',
        price: 110.00,
        category: 'Women',
        imageUrl: 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p27',
        name: 'High-Waist Jeans',
        description: 'Stretch high-waist skinny jeans in dark indigo wash. Sculpting fit.',
        price: 95.00,
        category: 'Women',
        imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p28',
        name: 'Trench Coat',
        description: 'Classic double-breasted trench coat in camel. Water-resistant cotton-gabardine.',
        price: 285.00,
        category: 'Women',
        imageUrl: 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p29',
        name: 'Pleated Midi Skirt',
        description: 'Flowing pleated midi skirt in emerald green satin. Elegant movement with every step.',
        price: 125.00,
        category: 'Women',
        imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p30',
        name: 'Cashmere Cardigan',
        description: 'Ultra-soft pure cashmere cardigan in oatmeal. Relaxed fit with pearl buttons.',
        price: 210.00,
        category: 'Women',
        imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cda3a98?auto=format&fit=crop&q=80&w=800',
      ),
    ];
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<ProductModel> get filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  ProductModel getProductById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }
}
