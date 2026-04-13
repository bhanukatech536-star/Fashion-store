import 'cart_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItemModel> items;
  final double totalPrice;
  final DateTime date;
  final String deliveryDetails;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.date,
    required this.deliveryDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<CartItemModel> parsedItems = itemsList
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return OrderModel(
      orderId: json['orderId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      items: parsedItems,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      deliveryDetails: json['deliveryDetails'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
      'deliveryDetails': deliveryDetails,
    };
  }
}
