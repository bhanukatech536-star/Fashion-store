import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistController extends ChangeNotifier {
  final List<ProductModel> _wishlistItems = [];

  List<ProductModel> get wishlistItems => _wishlistItems;

  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product.id)) {
      _wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      _wishlistItems.add(product);
    }
    notifyListeners();
  }
}
