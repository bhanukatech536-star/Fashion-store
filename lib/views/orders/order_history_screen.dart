import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/order_controller.dart';
import '../../widgets/shimmer_widgets.dart';
import '../../widgets/animations.dart';
import '../../core/theme.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isInitLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate fetching order history
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _isInitLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();
    final orders = orderController.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: _isInitLoading
          ? ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: 4,
              itemBuilder: (_, __) => const OrderItemSkeleton(),
            )
          : orders.isEmpty
              ? FadeInWidget(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'No past orders found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return StaggeredItem(
                      index: index,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.orderId.substring(0, 8)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$${order.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat.yMMMd().format(order.date),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.inventory_2_outlined,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text('${order.items.length} Items'),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PulsingDot(
                                          color: Colors.orange.shade600,
                                          size: 7),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Processing',
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
