import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartController extends ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => _items;

  int get itemCount {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItemModel(
          productId: existingCartItem.productId,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemModel(
          productId: productId,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
    } else if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItemModel(
          productId: existingCartItem.productId,
          quantity: quantity,
        ),
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
