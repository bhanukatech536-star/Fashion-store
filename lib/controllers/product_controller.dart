import 'package:flutter/material.dart';
import '../data/default_categories.dart';
import '../data/seed_products.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class ProductController extends ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  /// Filter chips in shop: All + category names from Firestore.
  List<String> get filterCategories => ['All', ..._categories.map((c) => c.name)];

  /// Dropdown options for admin product form.
  List<String> get shopCategoryNames => _categories.map((c) => c.name).toList();

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  ProductController() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _ensureDefaultCategories();
      await Future.wait([loadCategories(), loadProducts()]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _ensureDefaultCategories() async {
    final existing = await _firebase.fetchCategories();
    if (existing.isEmpty) {
      await _firebase.seedCategories(defaultCategories);
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _firebase.fetchCategories();
      if (_selectedCategory != 'All' &&
          !_categories.any((c) => c.name == _selectedCategory)) {
        _selectedCategory = 'All';
      }
    } catch (_) {
      _categories = [];
    }
    notifyListeners();
  }

  Future<void> loadProducts() async {
    try {
      _products = await _firebase.fetchProducts();
    } catch (_) {
      _products = [];
    }
    notifyListeners();
  }

  Future<void> refreshAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.wait([loadCategories(), loadProducts()]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    try {
      await _firebase.addProduct(product);
      await loadProducts();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      await _firebase.updateProduct(product);
      await loadProducts();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _firebase.deleteProduct(productId);
      await loadProducts();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addCategory(String name) async {
    try {
      await _firebase.addCategory(name);
      await loadCategories();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category, String newName) async {
    try {
      await _firebase.updateCategory(category, newName);
      await refreshAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> deleteCategory(CategoryModel category) async {
    try {
      final count = await _firebase.countProductsInCategory(category.name);
      if (count > 0) {
        return 'Cannot delete: $count product(s) use this category';
      }
      await _firebase.deleteCategory(category.id);
      await loadCategories();
      return null;
    } catch (_) {
      return 'Failed to delete category';
    }
  }

  Future<bool> seedSampleProducts() async {
    try {
      await _firebase.seedProducts(seedProducts);
      await loadProducts();
      return true;
    } catch (_) {
      return false;
    }
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
