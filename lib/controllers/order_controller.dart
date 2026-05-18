import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import '../services/firebase_service.dart';

class OrderController extends ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _firebase.fetchOrdersForUser(userId);
    } catch (_) {
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> placeOrder(
    String userId,
    List<CartItemModel> items,
    double totalPrice,
    String deliveryDetails,
  ) async {
    if (items.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final newOrder = OrderModel(
        orderId: const Uuid().v4(),
        userId: userId,
        items: items,
        totalPrice: totalPrice,
        date: DateTime.now(),
        deliveryDetails: deliveryDetails,
      );

      await _firebase.saveOrder(newOrder);
      _orders.insert(0, newOrder);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
