import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Dresses', 'Shoes', 'Accessories', 'Bags'];

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
      ProductModel(
        id: 'p1',
        name: 'Elegant Evening Dress',
        description: 'A stunning evening dress perfect for luxury events. Made with premium silk.',
        price: 299.99,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p2',
        name: 'Designer Leather Bag',
        description: 'Genuine leather handbag with elegant gold-tone hardware.',
        price: 159.50,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p3',
        name: 'Classic Stilettos',
        description: 'Black velvet stilettos for a timeless and sophisticated look.',
        price: 120.00,
        category: 'Shoes',
        imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p4',
        name: 'Gold Plated Necklace',
        description: 'Minimalist 18k gold plated necklace with a subtle pendant.',
        price: 85.00,
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca065b?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p5',
        name: 'Summer Floral Dress',
        description: 'Light and airy floral dress, perfect for summer outings.',
        price: 145.00,
        category: 'Dresses',
        imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&q=80&w=800',
      ),
      ProductModel(
        id: 'p6',
        name: 'Leather Crossbody',
        description: 'Compact crossbody bag with adjustable strap and premium leather.',
        price: 110.00,
        category: 'Bags',
        imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&q=80&w=800',
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
