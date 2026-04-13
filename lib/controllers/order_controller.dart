import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';

class OrderController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> placeOrder(
    String userId,
    List<CartItemModel> items,
    double totalPrice,
    String deliveryDetails,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    var uuid = const Uuid();
    final newOrder = OrderModel(
      orderId: uuid.v4(),
      userId: userId,
      items: items,
      totalPrice: totalPrice,
      date: DateTime.now(),
      deliveryDetails: deliveryDetails,
    );

    _orders.insert(0, newOrder);
    
    _isLoading = false;
    notifyListeners();
  }
}
