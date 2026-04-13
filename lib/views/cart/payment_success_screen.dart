import 'package:flutter/material.dart';
import '../../widgets/animations.dart';
import '../../widgets/custom_button.dart';
import '../../core/theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              FadeInWidget(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Payment Successful!',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(height: 16),
              FadeInWidget(
                delay: const Duration(milliseconds: 400),
                child: const Text(
                  'Your order has been placed successfully.\nYou will receive a confirmation email shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
                ),
              ),
              const Spacer(),
              FadeInWidget(
                delay: const Duration(milliseconds: 600),
                child: CustomButton(
                  text: 'BACK TO HOME',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeInWidget(
                delay: const Duration(milliseconds: 800),
                child: TextButton(
                  onPressed: () {
                    // Navigate to orders (would need to pop and switch tab, 
                    // or just pop until home and we can handle it there).
                    // For now, let's just go home.
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('VIEW ORDER DETAILS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
