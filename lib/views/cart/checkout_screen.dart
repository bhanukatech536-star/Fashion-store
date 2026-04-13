import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/animations.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalPrice;
  const CheckoutScreen({super.key, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser;
    if (user != null) {
      _addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final cartController = context.read<CartController>();
      final orderController = context.read<OrderController>();
      final authController = context.read<AuthController>();

      final items = cartController.items.values.toList();
      final userId = authController.currentUser?.id ?? 'guest';

      await orderController.placeOrder(
        userId,
        items,
        widget.totalPrice,
        _addressController.text,
      );

      if (mounted) {
        cartController.clearCart();
        Navigator.pushReplacement(
          context,
          AppPageRoute(child: const PaymentSuccessScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<OrderController>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInWidget(
                  delay: const Duration(milliseconds: 0),
                  child: const Text(
                    'Delivery Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInWidget(
                  delay: const Duration(milliseconds: 80),
                  child: CustomTextField(
                    label: 'Shipping Address',
                    hint: 'Enter your full delivery address',
                    controller: _addressController,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Address is required' : null,
                  ),
                ),
                FadeInWidget(
                  delay: const Duration(milliseconds: 160),
                  child: const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInWidget(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      _PaymentMethodCard(icon: Icons.credit_card, label: 'Card', isSelected: true),
                      const SizedBox(width: 12),
                      _PaymentMethodCard(icon: Icons.account_balance_wallet, label: 'PayPal', isSelected: false),
                      const SizedBox(width: 12),
                      _PaymentMethodCard(icon: Icons.apple, label: 'Apple Pay', isSelected: false),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FadeInWidget(
                  delay: const Duration(milliseconds: 240),
                  child: const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInWidget(
                  delay: const Duration(milliseconds: 220),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          Text('\$${widget.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee:',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey)),
                          Text('Free', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('\$${widget.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                FadeInWidget(
                  delay: const Duration(milliseconds: 300),
                  child: CustomButton(
                    text: 'PLACE ORDER',
                    isLoading: false, // overlay handles blocking UI
                    onPressed: isLoading ? () {} : _placeOrder,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _PaymentMethodCard({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
