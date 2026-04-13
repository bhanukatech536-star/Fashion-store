import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          _FAQItem(
            question: 'How can I track my order?',
            answer: 'You can track your order in the "Order History" section of your profile. Once dispatched, a tracking number will be provided.',
          ),
          _FAQItem(
            question: 'What is your return policy?',
            answer: 'We offer a 30-day return policy for all luxury items. Items must be in their original condition with tags attached.',
          ),
          _FAQItem(
            question: 'Do you ship internationally?',
            answer: 'Yes, we ship to over 50 countries worldwide. Shipping costs and delivery times vary by location.',
          ),
          SizedBox(height: 32),
          Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email Support'),
            subtitle: Text('support@luxefashion.com'),
          ),
          ListTile(
            leading: Icon(Icons.phone_outlined),
            title: Text('Phone Support'),
            subtitle: Text('+1 (800) LUXE-FASHION'),
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}
